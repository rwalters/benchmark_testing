require 'SecureRandom'

filename = "user_group.txt"

File.open(filename, "w") do |file|
  1_000_000.times do |t|
    user_id = SecureRandom.random_number(999) + 1000
    uuid    = SecureRandom.uuid

    file.puts "#{user_id}\t#{uuid}"
  end
end
