# Outputs the reading time
# Taken from: https://gist.github.com/zachleat/5792681

# Read this in “about 4 minutes”
# Put into your _plugins dir in your Jekyll site
# Usage: Read this in about {{ page.content | reading_time }}
module Jekyll
  module ReadingTime
    def ksreadtime( input )
      # words_per_minute = 180

      # words = input.split.size;
      # words = "america"
      # minutes = ( words / words_per_minute ).floor
      #minutes_label = minutes === 1 ? " minute" : " minutes"
      #minutes > 0 ? "about #{minutes} #{minutes_label}" : "less than 1 minute"
      return "abc"
    end
  end
end

Liquid::Template.register_filter(Jekyll::ReadingTime)
