require "videographer/speech_provider/base"
require "digest"
require "aws-sdk-polly"
require "videographer/config"

class Videographer::SpeechProvider::AwsPolly < Videographer::SpeechProvider::Base
  AUDIO_FREQUENCY = 16000

  def wav(text)
    hash = Digest::SHA256.hexdigest(text)
    cached = wav_cached_path(hash)
    return cached if File.exists?(cached)

    result = client.synthesize_speech({
      # lexicon_names: [
      #   "example",
      # ],
      output_format: "pcm",
      sample_rate: AUDIO_FREQUENCY.to_s,
      text: "<speak>" + text + "</speak>",
      text_type: "ssml",
      voice_id: "Brian",
    })

    pcm_file = Tempfile.new(["video_speech", ".pcm"], encoding: 'ascii-8bit')
    pcm_file.write(result.audio_stream.read.force_encoding("BINARY"))
    pcm_file.close

    pcm = pcm_file.path
    wav = cached
    
    FileUtils.mkdir_p wav_cached_path

    `sox -t s16 -r 16000 -b 16 -c 1 #{pcm} #{wav}`

    cached
  end

  protected
  def client
    amazon_client_args = { region: Videographer::Config.aws_region,
      access_key_id: Videographer::Config.aws_id,
      secret_access_key: Videographer::Config.aws_secret,
    }
    @client ||= Aws::Polly::Client.new(amazon_client_args)
  end
end
