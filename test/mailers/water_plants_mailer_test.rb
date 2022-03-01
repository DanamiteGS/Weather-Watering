require "test_helper"

class WaterPlantsMailerTest < ActionMailer::TestCase
  test "water_plant" do
    mail = WaterPlantsMailer.water_plant
    assert_equal "Water plant", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
