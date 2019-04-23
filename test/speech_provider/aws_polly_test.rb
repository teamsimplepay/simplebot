require "test_helper"

require "videographer/speech_provider/aws_polly"

class AwsPollyTest < Minitest::Test
  def test_wav
    Videographer::Config.aws_region = "eu-west-1"
    Videographer::Config.aws_id = ENV["AWS_2_ID"]
    Videographer::Config.aws_secret = ENV["AWS_2_SECRET"]
    polly = Videographer::SpeechProvider::AwsPolly.new
    polly.wav("Hello")
  end
end
