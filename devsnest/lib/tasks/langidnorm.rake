namespace :algoeditor do
    desc "replace lang_id to lang string"
    task replace_langid: :environment do
        lang_map = {
            # C 
            "50" => { 
              lang: "c"
             },
      
           # C++
            "54" => { 
              lang: "cpp"
             },
      
           # Java
            "62" => { 
              lang: "java"
             },
      
           # Javascript
            "63" => { 
              lang: "javascript"
             },
           
           # Python 2
            "70" => { 
              lang: "python"
             },
           
           # Python 3
            "71" => { 
              lang: "python3"
             },
      
           # Typescript
            "74" => { 
              lang: "typescript"
             }
            }

            AlgoSubmission.all.each do |submission|
                lang = lang_map.dig(submission.language.to_s, :lang)
                next if lang.nil?

                submission.update(language: lang)
            end
    
        
    end
end