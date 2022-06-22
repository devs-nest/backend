# frozen_string_literal: true

namespace :get_pendings do
  desc 'recheck pending submission'
  task run: :environment do

    
    jz_headers = { 'Content-Type': 'application/json', 'X-Auth-Token': ENV['JUDGEZERO_AUTH'], 'x-rapidapi-key': ENV['JZ_RAPID_KEY'] }
    pending_submissions_batches = AlgoSubmission.where(status: "Pending").first(100)
    done = 0
    err = []
    pending_submissions_batches.each do |pending_submissions|
      pending_submissions.each do |submission|
        submission[:test_cases].each do |token, stats|
          poll = HTTParty.get(ENV['JUDGEZERO_URL']+"/submissions/#{token.to_s}?base64_encoded=true", headers: jz_headers)
          begin
            res_hash = AlgoSubmission.prepare_test_case_result(JSON(poll.body))
            next if submission.test_cases[token]["status_description"].present?
            submission.with_lock do
              if AlgoSubmission.order_status(submission.status) <= AlgoSubmission.order_status(res_hash["status_description"])
                submission.status = res_hash["status_description"]
              end
              submission.total_runtime = submission.total_runtime.to_f + res_hash["time"].to_f
              submission.total_memory = submission.total_memory.to_i + res_hash["memory"].to_i
              submission.test_cases[token.to_s] = submission.test_cases[token.to_s].merge(res_hash)
              submission.passed_test_cases += 1 if res_hash["status_id"] == 3
              submission.status = 'Pending' if submission.status == 'Accepted' && submission.total_test_cases > submission.passed_test_cases
              submission.save!
            end
            done += 1
            p "Done for #{submission.id} : #{submission.status}"
            sleep(5) if done % 50 == 0
          rescue => e
            p "Error: #{e}"
            err << e
          end
        end
      end
    end
    p err
  end
end


 AlgoSubmission.where(status: "Pending", test_cases: {}).each do |s|
   if s.test_cases.empty?
     p s.id
   end
 end;0