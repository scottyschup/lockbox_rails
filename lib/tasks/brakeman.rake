def current_timestamp
  Time.now.to_s.gsub(/[:\-\s]/, '')
end

namespace :brakeman do
  desc "Run a full scan"
  task full_scan: :environment do
    cmd = "brakeman -A -o log/brakeman/#{current_timestamp}_fullscan.log"
    exec cmd
  end

  desc "Run a quick scan"
  task quick_scan: :environment do
    `brakeman --faster -o log/brakeman/#{current_timestamp}_quickscan.log`
  end
end
