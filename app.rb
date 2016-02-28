# -*- coding: utf-8 -*-
require 'roda'
require 'logger'

require_relative 'models'

unless KEEN_PROJECT_ID = ENV['KEEN_PROJECT_ID']
#  raise "You must specify the KEEN_PROJECT_ID env variable"
end

unless KEEN_WRITE_KEY = ENV['KEEN_WRITE_KEY']
#  raise "You must specify the KEEN_WRITE_KEY env variable"
end

unless KEEN_API_URL = ENV['KEEN_API_URL']
#  raise "You must specify the KEEN_API_URL env variable"
end

unless ENV['DATABASE_URL']
  raise "You must specify the DATABASE_URL env variable"
end

FUN_QUOTES =     ["Suffer, like G did!",
                  "Hq to all squads, there are reports of youths skating on 99th street. All unints nearby are ordered to investigate. I repeat, all units nearby are ordered to investigate.",
                  "Oh, hi. So, how are you holding up? BECAUSE I'M A POTATO!",
                  "The right man in the wrong place can make all the difference in the world.",
                  "Why, that's the second biggest monkey head I've ever seen!",
                  "A man chooses; a slave obeys.",
                  "It's time to kick ass and chew bubble gum, and I'm all out of gum.",
                  "Wait, that's not how it happened.",
                  "Objection!",
                  "Look behind you, a Three-Headed Monkey!",
                  "Wakka wakka wakka!",
                  "I've covered wars, you know.",
                  "EA Sports! It's in the game.",
                  "Job's done.",
                  "Good thinking, little buddy.",
                  "Every puzzle has an answer.",
                  "Hey! Listen!",
                  "Frankly, I'm ashamed.",
                  "It is pitch black. You are likely to be eaten by a grue.",
                  "Fus-ro-dah!",
                  "Say, 'fuzzy pickles'.",
                  "It's super effective!",
                  "Jason! Jaaaaaaaaason!",
                  "The Kid just rages for a while.",
                  "First blood"]

class NotMangekampen < Roda
  logger = Logger.new(STDOUT)

  use Rack::Session::Cookie, :secret => ENV['SECRET']

  plugin :render
  plugin :static, ['/images']
  plugin :error_handler do | e |
    FUN_QUOTES.sample
  end

  plugin :not_found do
    FUN_QUOTES.sample
  end

  route do |r|
    r.root do
      render('index')
    end

    r.is 'challenge/:id' do | id |
      @challenge = Challenge.find('uuid = ?', id)

      r.get do
        logger.info("Entering challenge #{@challenge.uuid}")
        render('challenge')
      end

      r.post do | id, answer |
        answer = r['answer']
        logger.info("Trying to answer #{@challenge.uuid} with #{answer}")
        # inform keen about the uuid and what the answer was
        if @challenge.answer.casecmp(answer) == 0
          logger.info("It was correct")
          next_challenge = Challenge.find('id = ?', @challenge.next)
          r.redirect("/challenge/#{next_challenge.uuid}")
        else
          logger.info("It was wrong")
          r.redirect("/challenge/#{@challenge.uuid}")
        end
      end
    end
  end
end
