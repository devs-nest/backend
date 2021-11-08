namespace :algoeditor do
    desc "runs ping to algo staging"
    task ping: :environment do
    
        body = {
            "data":{
                "attributes":{
                    "user_id": 1,
                    "challenge_id": 1,
                    "source_code": "a = int(input())\nb = int(input())\n\nprint(a*b)",
                    "language_id": 71
                },
                "type": "algo_submissions"
            }   
        
        }.to_json

        header = { "Content-Type": "application/vnd.api+json" }
        s_ids = []

        for i in 1..50 do
            obj = HTTParty.post("https://api.harry.devsnest.in/api/v1/algo-submission/", body: body, headers: header)
            obj_parsed = JSON.parse(obj.body)
            puts "recieved #{obj_parsed["data"]["id"]}"
            s_ids << obj_parsed["data"]["id"]
        end

        puts "Sleeping for 5 seconds..."
        sleep 5

        s_ids.each do |a|
            res = HTTParty.get("https://api.harry.devsnest.in/api/v1/algo-submission/#{a}")
            if res["data"]["attributes"]["test_cases"].count == res["data"]["attributes"]["total_test_cases"]
                puts "#{a} OK"
            else
                puts "#{a} failed"
            end
        end
    end
end