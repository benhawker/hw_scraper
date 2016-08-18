every :monday, :at => '12am' do
  runner "Report.generate"
end
