require "test_helper"

require 'videographer/video'

class VideographerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Videographer::VERSION
  end

  def test_simple_preview
    vid = TestVid.new
    vid.preview
  end

  def test_simple_record
    vid = TestVid.new
    `rm test.mov`
    vid.record("test.mov")
    assert File.size?("test.mov") > 200000
  end

  class TestVid < Videographer::Video
    def script
      visit "https://text.npr.org/"
      sleep 2      
    end
  end
end
