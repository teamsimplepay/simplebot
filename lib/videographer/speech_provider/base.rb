module Videographer module SpeechProvider class Base
  protected
  def wav_cached_path(name = nil)
    return "tmp/wav_cached" if name.nil?
    raise "Don't include .wav extension whem calling wav_cached_path" if name.end_with?(".wav")
    "tmp/wav_cached/#{name}.wav"
  end
end end end
