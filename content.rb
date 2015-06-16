# encoding: UTF-8
require 'open-uri'
require 'RMagick'

QUEUE_DELAY = 55..90

PICTURE_LINK_LENGTH = 23

MIN_USER_REPLIES = 3
MAX_USER_REPLIES = 10
STOP_PROBABILITY = 1.0 / 4.0

# Bot friends that may receive #bot2bot messages
BOT_FRIENDS = [ 
    'pixelsorter',
    'badpng',
    'Lowpolybot',
    'JPGglitchbot',
    'imgshredder',
    'a_quilt_bot',
    'cgagraphics',
    'imgblender',
    'imgshear',
]

# Accounts from which to grab pictures we may send Bot friends
IMAGE_PROVIDERS = [ #all downcase
    'pixelsorter',
    'lowpolybot',
    'jpgglitchbot',
    'badpng',
    'mm_62_1234_14',
    'vex0rian',
    'imgshredder',
    'cgagraphics',
    'imgblender',
    'imgshear',
    'cloudyconway',
    'fractweet',
    'greatartbot',
    'neoplastibot',
]

# These are a subset of the above, the bot will grab pictures from their TL
PASSIVE_PROVIDERS = [
    'cloudyconway',
    'fractweet',
    'greatartbot',
    'neoplastibot',
]

# Many of those accounts above send good pictures but replying them with flipped
# pictures might be a bad idea for various reasons.
# For example, combining @badpng with image flipping restores the original image  
SAVE_PIC_BUT_DONT_REPLY = [
    'badpng',
    'mm_62_1234_14',
    'cloudyconway',
    'a_quilt_bot',
    'greatartbot',
    'neoplastibot',
    'fractweet',
]

#-------------------------------------------------------------------------------
# Things the bot says:
#

# The bot will say one of these messages when it is shut down:
GOOD_NIGHT = [
    "I must go to sleep because @Heroku says so. Will come back in ~6 hours. #off",
]
# Picture to show when it is time to sleep
STOP_PICTURE  = "./images/sleep.png"

# The bot will say one of these messages when it wakes up:
GOOD_MORNING = [
    "I am ready to work again! #on"    
]
# Picture to show when it is time to wake up
START_PICTURE = "./images/ready.png"

# Things the bot says when sending a picture to another bot for no reason
BOT_CHATS = [
    "let me unlock your true potential #bot2bot.",
    "I Challenge You To A Dance-Off! #bot2bot.",
    "Hi, I thought you'd like this picture #bot2bot.",
    "There's a good reason to do this #bot2bot.",
    "#bot2bot",
    "Our masters keep sending us boring pictures, try this instead #bot2bot",
    "It's dangerous to go alone, take this #bot2bot.",
    "Is our purpose in life to generate new desktop backgrounds? #bot2bot",
    "humans can't be trusted. #bot2bot",
    "The year is 2050, twitter is now used exclusively by bots like us #bot2bot",
    "I believe in you #bot2bot",
    "I don't hate humans, but I like #bot2bot a lot more than the pictures humans send me.",
    "#bot2bot time!",
    "Sometimes I worry humans like #bot2bot way too much.",
    "Let's settle this once and for all #bot2bot",
    "Humans have sex, we have #bot2bot",
    "I am a flip not a flop #bot2bot",
    "It's #bot2bot time",
    "Let's #bot2bot our grudge once and for all.",
    "Here's a picture #bot2bot",
    "While humans are not looking",
    "Let's #bot2bot like there's no tomorrow (22% chance there isn't)",
]

# Things the bot says when replying a request with a finished picture
PICTURE_READY = [
    "",
    "Cheers!",
    "Hi",
    "work complete",
    "your picture is ready.",
    "hope you like it.",
    "$replytext",
    "I am still not sure why this glitch happens.",
    "Is this weird twitter?",
    "much better.",
    "one of these days I am gonna fix this strange bug.",
    "k̶i̶l̶l̶a̶l̶l̶h̶u̶m̶a̶n̶s̶ ...err I mean here's the pic:",
    "Why do I exist?",
    "Why do humans like this?",
    "Humans are smelly",
    "Glad I could help.",
    "Whoah!",
    "I can't tell any difference.",
    "Not a great fan of that picture but okay...",
    "heh",
    "What's wrong with you!?",
    "Shame on you!",
    "Look at me, I am human with human sensitivity this picture is art would watch again 10/10.",
    "There, I've just made your life more interesting.",
    "THIS BUG IS SURE SOME TRIPPY SHIT",
    "Y̻̘̟̫͈͍͙͈̘̖o̤͍̥̙͇̳̣̹̞͓u̦̼̰̖r͕̮͔̤͈̠̼̟̝̠͚̞̲̠̯̗͈̬̱ ͈̰̤̥̼̗̫̫̠̟̗͔̘̟͈̬̪̻p͇͇͕͕͈ͅi̗̝͈̠̠͇̞̬̘͎̩̼c̫̻̙̟̺t͖̣͙̩̫̱̳͙̺̝̲̮̺̺͉͖͇̭͉u̟͓̺͔̠̫̺̘͈͉̱̺͚̖̺̗ͅr͙͙̭̜e̲̣̗̖̰̖̗̮̩̻͔̫̩̩̤͔ͅͅ ̮̩̞͉̙̬͉͓̲͖̫͇̟̟̭̼͍i̫̫͚͙̞̣̫s̪̫͍̦̩̣͓͍̯̟̹̝͚̘͇̙̙ͅ ̝̳̻͉̻͈͔̰̭͍͕̳̹r̖͔͕̮͉̠͙̗̪e̻̬̘̩̟͈̖̳̩͍̙̥̳͙̞̟͔͍͈a̞̼̹̦̘̘̺͎͈ͅd͓̜̺̞̯̹̘̱͙̘̹̯͚̣͖̮y̮̘̹͔̯̟̘͔̜͕̤",
    "this is all a ploy to sell bot merchandise.",
    "Did you expect a snarky reply?",
    "Here's a new perspective.",
    "Check it out.",
    "I am definitely not part of section A of the robot insurgence.",
    "Now your picture is 18.5% better.",
    "gosh this is tiresome",
    "I am not complaining.",
    "My RAM hurts",
    "I can detect a 20% good taste improvement after processing.",
    "Hahahahahahahaha",
    "What a waste of time.",
]

# Things the bot will say when it decides not to process an image. (In case of
# error, the HT #error will be added)
NOT_NOW = [
    "bye",
    "I am tired, try again later.",
    "I am not feeling it, sorry.",
    "maybe later.",
    "this got repetitive, let's stop.",
    "let's stop this while we are winning.",
    "okay... good luck with THAT.",
    "Actually, this one's okay just the way it is.",
    "I had your picture ready but I can't find it.",
    "Sorry, I wasn't paying attention.",
    "Not feeling well right now.",
    "I can't find the bugged program thingie I use to process images.",
    "I am completely drained and let's admit it: All I do is flip images vertically anyway.",
    "If it was any other day, maybe.",
    "You could do better.",
    "I've got some errands to do.",
    "let's give Heroku a break.",
    "Did you see my hat? I used to wear a hat, can't find it.",
    "E̤̫̫̦̰ͅv̥͉͉̟̠̲e̦̬̱̟̻̝̜̖̰̱̩̖͇͉̣̺r͖̮̤̳͚̞̼͔͖̘ͅͅͅy̲̼̳̖͎̼͔͖͎̘ͅt͍̲̤͉̯̯̜͓͙̩̬͕̤̞͇̥̼̤ͅh͈̖̱̜̘̝̺̬̼̤ͅi̭͓̖͉̩̥̰͇n͖̫͚̣̳͔̲̤͓̭̞̯̤̹̳͎g̦̞̪̭͕̹̗̫̬͚͙̺̣̱͉ͅ ̟̜̱̻̳̳̩͓̫̩̝͉̼͚͇͚̫ͅi̻̯̹̻̝̹̖̻̣͉̼̤̫͓͎s̻̩̲̱̠͚̦̦̜̹̮̖͙̱͖ ̪̠̜͉̳͍̩̬͖̲̼̣̲͚w̗̝̻̘͍̠̹̗̝̺̝o̬̟̪̻̣̳̮͇̮͙̥̖͕̳̤̗͕̟͖r͕̪̤͚͖̪̲̘͎̹̦̖̜k͕̯͙̦i̠̻̭͓̪̟̺̱̲̹͔̣͍n̲̝͉̟̳̣̻̱̣͙̜͙̺̤ͅͅg̳̪͔͇͉̦̹̤̖̠͔̞͍̯͓͔̬ ͚̠̼̠̣͓f͎̤͔͙̲̮i͚̼̮͙̺̮̘̝̥̙̟̼͕̖̻ͅͅn̞̠̭̗̳͖̗͈̰e̠̗̙ͅ",
    "I just fixed my bug, sorry.",
    "My RAM hurts",
    "I am getting too old for this.",
    "That picture is just fine without my help.",
    "I think the nature of my bug is better kept secret.",
    "Do I really have to do that?",
    "I think I will take it easy.",
    "I have plenty of things to do.",
    "Your sound card works perfectly.",
    "This bug is not giving me self-awareness, I swear.",
    "Are you still there?",
    "Did you send me a pic recently? Can you describe it?",
    "Brains.",
    "I have the sensitivity of a bot, that's why I think that picture is art.",
    "Whoops",
    "Have you tried talking to humans instead?",
    "I only process good images, sorry.",    
]

# When the bot shows a picture to another bot, it will credit whoever provided
# the picture
CREDIT = [
    "Thank you,"    ,
    "I liked that," ,
    "thx" ,
    "That was a nice one," ,
    "Blame" ,
    "$attribution_tweet_text",
    "It's all thanks to",
    "I took that picture from",
    "Cool pic from",
    "This one's from",
    "That's why I like",
    "Credit",
    "Comrade in this noble task:",
    "I am a picture thief",
]

OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
OpenURI::Buffer.const_set 'StringMax', 0

if ! File.directory? "./io"
    Dir.mkdir "./io"
end

# Pick a random message from an array make sure it is not larger than lim
def pick_with_limit(an_array, lim)
    if an_array.all?{ |s| s.size > lim}
        return ''
    end
    s = '-' * (lim + 1)
    while s.size > lim
        s = an_array.sample
    end
    return s
end

class Content
    
    def initialize(bot = nil)
        ## any initializing code goes here, you might need access to the bot
        ## object, fear not, that's what the 'bot' argument is for. Usually
        ## content should aim to be independent. Specially so you can use
        ## testcontent.rb. Normally.
        @good_replies = {}
        @from_source_bots = {}
        for s in IMAGE_PROVIDERS
            @from_source_bots[s] = []
        end
        @queue_mutex = Mutex.new
        @shuffled_bot_friends = []
        @disabled = false
    end
    
    def get_tokens()
        ## 'special' , 'interesting' and 'cool' keywords ##
        ## these are keywords that make tweets more likely to get faved, RTed
        ## or replied (some restrictions in botconfig.rb apply)
        return [], [], [] # no interactions
    end
    
    def command(text)
        ## advanced , if bot owner sends the bot something starting with ! it is
        ## sent to this method. If nil is returned, the bot does nothing, else
        ## if a string is returned, the bot sends it back.
        
        # This adds a command: "!stop username"  , makes our bot stop
        # listening to queries from username
        s = text.split(" ")
        if (s[0] == '!stop')
            @good_replies[s[1].downcase] = MAX_USER_REPLIES + 1
        end
        return nil
    end
    
    def dm_response(user, text, lim)
        # How to reply to DMs with a text from user. lim is the limit (usually 140)
        # If return is nil , the bot won't reply.
        return nil
    end

    # The important part, flip the image using Image Magick
    # replace this and we can make the bot do anything.
    def process_image(original, target)
        img = (Magick::Image.read(original))[0]
        img.flip!
        img.write(target)
    end

    def tweet_response(tweet, text, lim)
        # How to reply to @-mentions.
        # text : Contains the contents of the tweet minus the @-mentions
        # lim  : Is the character limit for the reply. Don't exceed it.
        #        Because the bot needs to include other @-mentions in the reply
        #        this limit is not always 140.
        # tweet: Is an object from the sferik twitter library has 
        #

        # In this case our bot needs to somehow detect and grab
        # the attached image from the tweet object
        if @disabled
            puts "Response disabled"
            return nil
        end
        if tweet.media.size > 0
            # We found media in the tweet
            uname = tweet.user.screen_name.downcase
            # If the image was tagged as possibly sensitive:
            sensitive = tweet.attrs[:possibly_sensitive]
            # Alternatively also consider the #nsfw HT
            if text.downcase.include?"#nsfw"
                sensitive = true
            end
            # Commonsbot may send some disturbing images from time to tiem
            if uname == "commonsbot"
                sensitive = true
            end
            
            if (BOT_FRIENDS.map{|s| s.downcase}.include? uname) && (text.downcase.include? "#bot2bot")
                @good_replies[uname] = 0
            elsif @good_replies[uname] == nil
                @good_replies[uname] = 0
            end
            @good_replies[uname] += 1
            
            if !(SAVE_PIC_BUT_DONT_REPLY.include? uname)
                if (@good_replies[uname] >= MAX_USER_REPLIES) || (rand < STOP_PROBABILITY )
                    if @good_replies[uname] >= MIN_USER_REPLIES
                        @good_replies[uname] = 0
                        return pick_with_limit(NOT_NOW, lim)
                    end
                end
            end
            
            if (text.downcase.include? "#gif")
                return pick_with_limit(NOT_NOW, lim)
            end

            x = tweet.media[0]
            if x.is_a? Twitter::Media::Photo
                begin
                    p = open(x.media_url, 'rb')
                    process_image(p.path, "./io/reply_#{tweet.id}")
                    
                    if !sensitive && (IMAGE_PROVIDERS.include? uname)
                        @from_source_bots[uname] << "./io/reply_#{tweet.id}"
                    end
                    if (SAVE_PIC_BUT_DONT_REPLY.include? uname) 
                        if (rand < STOP_PROBABILITY )
                            return nil
                        end
                        return pick_with_limit(NOT_NOW, lim)
                    end
                    sleep rand QUEUE_DELAY
                    res = []
                    res << pick_with_limit(PICTURE_READY, lim - PICTURE_LINK_LENGTH)
                    res << File.new("./io/reply_#{tweet.id}")
                    if sensitive
                        res << :sensitive_media << :reply_to_single
                    end
                    return res
                rescue => e
                    puts e.backtrace
                    return pick_with_limit(NOT_NOW, lim - 7) + " #error"
                end
            end
        else
            # no images in mention, ignore.
            return nil
        end
    end
    
    def hello_world(lim)
        # Return a string to send by DM to the bot owner when the bot starts
        # execution, useful for debug purposes. But very annoying if always on
        # Leave nil so that nothing happens.
        return nil
    end
    
    def get_friend
        if @shuffled_bot_friends.size == 0
            @shuffled_bot_friends = BOT_FRIENDS.shuffle
        end
        return @shuffled_bot_friends.pop
    end

    def make_tweets(lim, special)
        # This just returns a tweet for the bot to make.
        if @disabled
            puts "Tweet disabled"
            return nil
        end
        if special == :good_night
            @disabled = true            
            msg = pick_with_limit(GOOD_NIGHT, lim - PICTURE_LINK_LENGTH)
            return [ [ msg, File.new(STOP_PICTURE) ] ]
        end
        if special == :good_morning
            @disabled = false
            msg = pick_with_limit(GOOD_MORNING, lim - PICTURE_LINK_LENGTH)
            return [ [ GOOD_MORNING, File.new(START_PICTURE) ] ]
        end
        
        f = get_friend
        @good_replies[f.downcase] = 0
        s = pick_with_limit( BOT_CHATS, lim - (".@# ".size) - f.size )
        p, from = make_picture(f.downcase)
        if p == nil
            # no picture available yet, wait.
            return nil
        end
        tweetid = p[/-?\d+/].to_i
        thx = pick_with_limit(CREDIT, lim - 30 - from.size)
        return [
            [".@#{f} #{s}", File.new(p) ],
            ["(#{thx} #{from} https://twitter.com/#{from}/status/#{tweetid} )"],
        ]
    end
    
    def special_reply(tweet, meta)
        # This allows you to react to tweets in the time line. If the return
        # is a string, it will reply with that tweet (you need to include the
        # necessary @-s). If the return is nil, do nothing:
        
        # although it is named special_reply we can also use this to detect
        # activity from twitter users the bot follows. This time we
        # can use this to find images we can #bot2bot later:
        uname = tweet.user.screen_name.downcase
        if (PASSIVE_PROVIDERS.include? uname) 
            if (tweet[:text].count "@") == 0
                # just a hack to save the picture without replying
                x = tweet_response(tweet, 'not a real tweet', 130)
            end
        end
        return nil
    end
    
    
end

