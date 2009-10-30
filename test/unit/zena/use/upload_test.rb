require 'test_helper'

class UploadTest < Zena::View::TestCase
  include Zena::Use::Upload::ControllerMethods
  attr_reader :params

  def self.has_network?
    response = nil
    Net::HTTP.new('example.com', '80').start do |http|
      response = http.head('/')
    end
    response.kind_of? Net::HTTPSuccess
  rescue
    false
  end

  # only run these tests if network is available
  if has_network?
    context 'Uploading with an attachment url' do
      setup do
        @params = {'attachment_url' => 'http://zenadmin.org/fr/blog/image5.jpg'}
      end

      should 'provide a file with the downloaded content' do
        file, error = get_attachment
        assert file, "error: #{error}"
        content = file.read
        assert_equal 73633, content.size
      end

      context 'to a file too large' do
        setup do
          @params = {'attachment_url' => "http://cdimage.debian.org/debian-cd/5.0.3/i386/iso-cd/debian-503-i386-CD-1.iso"}
        end

        should 'return an error about file being too big, without a download' do
          file, error = get_attachment
          assert_nil file
          assert_equal 'size (645.5 MB) too big to fetch url', error
        end
      end

      context 'to a file without size' do
        setup do
          @params = {'attachment_url' => "http://download.berlios.de/zena/zena_playground.zip"}
        end

        should 'return an error about missing content length' do
          file, error = get_attachment
          assert_nil file
          assert_equal 'unknown size: cannot fetch url', error
        end
      end


      context 'that is not valid' do
        setup do
          @invalid_urls = ['lkja a93z/3', 'bad .uri', '.']
        end

        should 'return an error' do
          @invalid_urls.each do |url|
            @params = {'attachment_url' => url}
            file, error = get_attachment
            assert_nil file
            assert_equal 'invalid url', error
          end
        end
      end

      context 'that does not exist' do
        setup do
          @params = {'attachment_url' => "http://example.org/xyz.zip"}
        end

        should 'return an error about missing content length' do
          file, error = get_attachment
          assert_nil file
          assert_equal 'not found', error
        end
      end
    end
  else
    puts "upload by url disabled (no network)"
  end # if has_network?
end