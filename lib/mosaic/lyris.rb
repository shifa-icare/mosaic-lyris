%w(
  object
  demographic
  filter
  list
  lyris_message
  partner
  record
  trigger
).each do |file|
  require File.join(File.dirname(__FILE__),'lyris',file)
end
