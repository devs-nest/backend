# frozen_string_literal: true

# Helper for Leetcode Integration
module LeetcodeHelper
  class LeetUser
    def initialize(username = nil)
      raise "Username is required" if username.nil?

      @username = username
      @url = "https://leetcode.com/graphql"
      @headers = { "content-type": "application/graphql" }
    end

    def UserPublicProfile
      <<-GRAPHQL
        query userPublicProfile {
          matchedUser(username: "#{@username}") {
            contestBadge {
              name
              expired
              hoverText
              icon
            }
            username
            githubUrl
            twitterUrl
            linkedinUrl
            profile {
              ranking
              userAvatar
              realName
              aboutMe
              school
              websites
              countryName
              company
              jobTitle
              skillTags
              postViewCount
              postViewCountDiff
              reputation
              reputationDiff
              solutionCount
              solutionCountDiff
              categoryDiscussCount
              categoryDiscussCountDiff
            }
          }
        }
      GRAPHQL
    end

    def LanguageStats
      <<-GRAPHQL
        query languageStats {
          matchedUser(username: "#{@username}") {
            languageProblemCount {
              languageName
              problemsSolved
            }
          }
        }
      GRAPHQL
    end

    def UserProblemsSolved
      <<-GRAPHQL
        query userProblemsSolved {
          allQuestionsCount {
            difficulty
            count
          }
          matchedUser(username: "#{@username}") {
            problemsSolvedBeatsStats {
              difficulty
              percentage
            }
            submitStatsGlobal {
              acSubmissionNum {
                difficulty
                count
              }
            }
          }
        }
      GRAPHQL
    end

    def UserProfileCalendar
      <<-GRAPHQL
        query userProfileCalendar($year: Int) {
          matchedUser(username: "#{@username}") {
            userCalendar(year: $year) {
              activeYears
              streak
              totalActiveDays
              dccBadges {
                timestamp
                badge {
                  name
                  icon
                }
              }
              submissionCalendar
            }
          }
        }      
      GRAPHQL
    end
  
    def query(query_schema = "UserPublicProfile")
      JSON.parse(HTTParty.get(@url, body: send(query_schema), headers: @headers).body)
    end

    def prepare_results
      {
        public_profile: query("UserPublicProfile"),
        language_stats: query("LanguageStats"),
        problems_solved: query("UserProblemsSolved"),
        profile_callender: query("UserProfileCalendar"),
      }
    end
  end
end