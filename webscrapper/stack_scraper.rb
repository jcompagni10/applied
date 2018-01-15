require "wappalyzer_rb"

def get_stack(url)
  base = url.gsub("www.", "")
  stack = []
  prefixes = %w["" www. http:// https:// http://www. https://www.]
  prefixes.each do |prefix|
    begin
      # p "trying " + prefix + base
      stack += WappalyzerRb::Detector.new(prefix + base).analysis
    rescue
      puts "error with prefix:" + prefix
    end
  end
  p stack.uniq
end

get_stack(ARGV[0])

