%w(
  object
  demographic
  filter
  list
  upload
  message
  partner
  record
  template
  trigger
).each do |file|
  require File.join(File.dirname(__FILE__),'lyris',file)
end
