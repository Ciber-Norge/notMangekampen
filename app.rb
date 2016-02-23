require 'roda'

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
