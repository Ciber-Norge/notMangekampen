require 'roda'

unless KEEN_PROJECT_ID = ENV['KEEN_PROJECT_ID']
  raise "You must specify the KEEN_PROJECT_ID env variable"
end

unless KEEN_WRITE_KEY = ENV['KEEN_WRITE_KEY']
  raise "You must specify the KEEN_WRITE_KEY env variable"
end

unless KEEN_API_URL = ENV['KEEN_API_URL']
  raise "You must specify the KEEN_API_URL env variable"
end

unless DATABASE_URL = ENV['DATABASE_URL']
  raise "You must specify the DATABASE_URL env variable"
end


class NotMangekampen < Roda
  use Rack::Session::Cookie, :secret => ENV['SECRET']

  plugin :render
  plugin :static, ['/images']

  route do |r|
    r.root do
      render('index')
    end
  end
end
