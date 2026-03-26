# NOTES
# - order matters
#     destroy children → destroy parents
#     create parents → create children
# - associations > IDs --> cleaner and safer
#     instead of: user_id: users.sample.id
#     use: user: users.sample

# Base path for all seed images, organised in per-user subfolders. MJR
SEEDS_IMAGES_PATH = Rails.root.join("db/seeds/images")

# ---------------------------
# CLEAN THE DATABASE
# ---------------------------
puts "Cleaning database..."
Like.destroy_all
Comment.destroy_all
Photo.destroy_all
Answer.destroy_all
Question.destroy_all
Questionnaire.destroy_all
Task.destroy_all
Message.destroy_all
Chat.destroy_all
# Clean noticed gem tables and legacy notifications table before destroying users
# (these have foreign keys to users but have no Ruby model class)
conn = ActiveRecord::Base.connection
conn.execute("DELETE FROM noticed_notifications") if conn.table_exists?("noticed_notifications")
conn.execute("DELETE FROM noticed_events")       if conn.table_exists?("noticed_events")
conn.execute("DELETE FROM notifications")        if conn.table_exists?("notifications")
User.destroy_all
puts "Database cleaned ✅"

# ---------------------------
# 1. USERS
# ---------------------------
puts "Creating users..."

# Hardcoded user profiles for the presentation — each reflects a different journey stage. MJR
users_data = [
  {
    name: "Mario Rieboldt",
    email: "mario@test.com",
    password: "password",
    status: "pre_flight",
    batch_number: 2026,
    program_duration: 5,
    departure_date: Date.new(2026, 8, 15),
    date_of_birth: Date.new(2010, 9, 24),
    role: :user,
    folder: "Mario"
  },
  {
    name: "Helena Wali",
    email: "helena@test.com",
    password: "password",
    status: "in_canada",
    batch_number: 2026,
    program_duration: 10,
    departure_date: Date.new(2026, 8, 15),
    date_of_birth: Date.new(2010, 10, 11),
    role: :user,
    folder: "Helena"
  },
  {
    name: "Niels van Duijn",
    email: "niels@test.com",
    password: "password",
    status: "in_canada",
    batch_number: 2026,
    program_duration: 5,
    departure_date: Date.new(2026, 2, 15),
    date_of_birth: Date.new(2011, 4, 1),
    role: :admin,
    folder: "Niels"
  },
  {
    name: "Manu Gass",
    email: "manu@test.com",
    password: "password",
    status: "post_canada",
    batch_number: 2026,
    program_duration: 10,
    departure_date: Date.new(2026, 2, 15),
    date_of_birth: Date.new(2009, 12, 15),
    role: :user,
    folder: "Manu"
  }
]

# Maps folder name to user object so photos can be assigned to the correct user below. MJR
users = {}

users_data.each do |data|
  folder = data.delete(:folder)
  user = User.create!(data)

  # Attach each user's avatar from their seed folder — supports both .jpg and .jpeg. MJR
  avatar_path = Dir.glob("#{SEEDS_IMAGES_PATH}/#{folder}/Avatar.{jpg,jpeg}").first
  if avatar_path
    user.avatar.attach(
      io: File.open(avatar_path),
      filename: File.basename(avatar_path),
      content_type: "image/jpeg"
    )
  end

  users[folder] = user
end

puts "Created #{User.count} users"

# ---------------------------
# 2. PHOTOS
# ---------------------------
puts "Creating photos..."

# Captions per user — matched to photos by index order.
# Written in social media style with emojis and hashtags. MJR/HW
photo_captions = {
  "Mario" => [
    "First day in Canada! 🍁✈️ I received my Canada starting kit: nice shirt and hockey sticks #CanadaBound #ExchangeYear #LetsGo",
    "Meeting new friends — so excited I can barely breathe! 🎒😍 #Packing #AdventureAwaits #CanadaUniqueExchange",
    "Meeting the best people in Canada 🥺❤️ Lokking forward for 5 great months! #OhCanada #ExchangeLife #FeelingGood",
    "Hockey vibes loading ✈️🛫 Next stop: Stadium! #HockeyVibes #OffWeGo #ExchangeYear"
  ],
  "Helena" => [
    "I MADE IT TO VANCOUVER 🍁🏔️ The the food is fantastic #Vancouver #ExchangeYear #CanadaUniqueExchange",
    "First day at school done! A lot of Canada is going on 😊🎒 #NewSchool #ExchangeLife #VancouverVibes",
    "Weekend hike with my friends 🥾🌲 Nature therapy hits different in Canada #Hiking #NatureLovers #BCWild",
    "Canadian breakfast >>> 🍁🥞 Maple syrup on everything, no notes #CanadianFood #MapleLife #Brunch",
    "NIAGARA FALLS 🌊🤯 Worth. Every. Second. #NiagaraFalls #Ontario #MustSee",
    "My first ride on a moose!! ☺️🦌 So much fun!! #NiceDay #CruisingDownTheStreets #NorthVancouver"
  ],
  "Niels" => [
    "The best friends ever 🥳🍀 #SchoolExchange #Toronto #ExchangeLife",
    "Hockey game last night and my voice is GONE 🏒🇨🇦 Best atmosphere I have ever experienced #NHL #HockeyNight #Toronto",
    "Maple syrup tasting at the market 🍁😋 I may have bought too many bottles #MapleLife #StLawrenceMarket #Toronto",
    "Downtown in my lovely city 🌊🤯 Worth. Every. Second. #BestCityEver #Ontario #MustSee",
    "SNOW DAY!! ❄️⛄ My first real snow and I am obsessed #SnowDay #WinterWonderland #BestHorsesInCanada"
  ],
  "Manu" => [
    "Missing Canadian winters so much right now ❄️😭 Nothing compares #PostCanada #MissingCanada #HomeIsWhereTheSnowIs",
    "Going through my photos and crying a little 🥺📸 Best year of my life #ExchangeYear #Memories #CanadaForever",
    "Final day at school still not over it 🎓🥲 Thank you for everything Canada #FinalDay #Gratitude #ExchangeLife",
    "Best Pizza ever !! 🇨🇦🇩🇪 I will never forget the wonderful taste #SuperSweet #ExchangeEnds #SeeYouSoon",
    "One year later and I still dream about Canada every single night 🍁💭 #OneYearAnniversary #ForeverGrateful #CanadaUnique"
  ]
}

# Locations per user — index matches the caption above (caption 0 → location 0).
# All locations are in Canada to match the seed's Canada-focused context.
# Each user is placed in a different Canadian city, with real high school names
# used where the photo context fits a school setting. HW
photo_locations = {
  "Mario" => [
    "Ottawa, ON, Canada",
    "Ottawa, ON, Canada",
    "Lisgar Collegiate Institute, Ottawa, ON",
    "Ottawa Macdonald-Cartier International Airport, ON"
  ],
  "Helena" => [
    "Vancouver, BC, Canada",
    "Kitsilano Secondary School, Vancouver, BC",
    "Grouse Mountain, BC, Canada",
    "Vancouver, BC, Canada",
    "Downtown Vancouver, BC, Canada",
    "North Vancouver, BC, Canada"
  ],
  "Niels" => [
    "CN Tower, Toronto, ON",
    "Scotiabank Arena, Toronto, ON",
    "St. Lawrence Market, Toronto, ON",
    "Niagara Falls, ON, Canada",
    "Northern Secondary School, Toronto, ON"
  ],
  "Manu" => [
    "Montreal, QC, Canada",
    "Montreal, QC, Canada",
    "Westmount High School, Montreal, QC",
    "Montreal-Trudeau International Airport, QC",
    "Montreal, QC, Canada"
  ]
}

all_photos = []

users.each do |folder, user|
  captions  = photo_captions[folder]  || []
  locations = photo_locations[folder] || [] # look up the matching location list for this user
  # Scope photos to each user's own folder so users get their own images, not a shared pool. MJR
  user_photos = Dir.glob("#{SEEDS_IMAGES_PATH}/#{folder}/[Pp]hoto*").sort

  captions.each_with_index do |caption, index|
    file = user_photos[index % user_photos.length]
    photo = Photo.create!(
      description: caption,
      location:    locations[index], # index keeps caption and location in sync
      user: user,
      shared: [true, true, false].sample
    )
    photo.image.attach(
      io: File.open(file),
      filename: File.basename(file),
      content_type: "image/jpeg"
    )
    all_photos << photo
  end
end

puts "Created #{Photo.count} photos"

# ---------------------------
# 3. COMMENTS
# ---------------------------
puts "Creating comments..."

# Realistic comment texts — randomly assigned to in_canada photos by other users. MJR
comment_texts = [
  "Looks amazing!",
  "So jealous, wish I was there!",
  "Love this photo!",
  "Canada looks incredible",
  "Miss you!",
  "This is so cool!",
  "The view is unreal",
  "Having the time of your life!",
  "Can't wait to visit",
  "Best exchange year ever!"
]

users_list = users.values
# Focus comments on in_canada photos to make the community feed feel active. MJR
in_canada_photos = all_photos.select { |p| p.user.status == "in_canada" }

15.times do
  photo = in_canada_photos.any? ? in_canada_photos.sample : all_photos.sample
  commenter = (users_list - [photo.user]).sample
  Comment.create!(
    text: comment_texts.sample,
    user: commenter,
    photo: photo
  )
end

puts "Created #{Comment.count} comments"

# ---------------------------
# 4. LIKES
# ---------------------------
puts "Creating likes..."

# Track user+photo pairs to prevent duplicate likes. MJR
liked_combinations = []
20.times do
  photo = all_photos.sample
  liker = (users_list - [photo.user]).sample
  next if liked_combinations.include?([liker.id, photo.id])
  liked_combinations << [liker.id, photo.id]
  Like.create!(user: liker, photo: photo)
end

puts "Created #{Like.count} likes"

# ---------------------------
# 5. CHATS & MESSAGES
# ---------------------------
puts "Creating chats and messages..."

# Hardcoded AI chat conversations per user — reflects their journey stage. MJR
chat_conversations = {
  "Mario" => [
    { role: "user",      content: "What should I pack for Canada in August?" },
    { role: "assistant", content: "For August in Canada I'd recommend light layers as mornings can be cool. Don't forget a good rain jacket, comfortable walking shoes, and sunscreen. Also bring an adapter for Canadian outlets!" },
    { role: "user",      content: "What about money? Should I bring cash or use my card?" },
    { role: "assistant", content: "Cards are widely accepted in Canada. I'd recommend bringing a small amount of Canadian cash (around $100-200) for emergencies. Notify your bank before you travel to avoid your card being blocked." }
  ],
  "Helena" => [
    { role: "user",      content: "I just arrived in Vancouver! Any tips for getting around?" },
    { role: "assistant", content: "Welcome to Vancouver! The public transit system (TransLink) is excellent - get a Compass Card for buses and the SkyTrain. Downtown is very walkable too. The SeaBus to North Vancouver is a great experience!" },
    { role: "user",      content: "What are some must-see places near Vancouver?" },
    { role: "assistant", content: "You absolutely must visit Stanley Park - it's stunning. Granville Island Market is great for local food and crafts. A day trip to Whistler is worth it, and take the Sea-to-Sky Highway to Squamish if you can." }
  ],
  "Niels" => [
    { role: "user",      content: "What's the best way to experience Canadian culture?" },
    { role: "assistant", content: "Go to a live hockey game - it's unlike anything else! Try poutine, visit a Tim Hortons, explore local farmers markets, and attend a local festival. Canadians are very friendly so don't be shy!" },
    { role: "user",      content: "Any tips for making friends at a Canadian school?" },
    { role: "assistant", content: "Join extracurricular activities - sports teams, clubs, or student council are great ways to meet people. Canadians are generally very welcoming to exchange students. Be open and share your culture!" }
  ],
  "Manu" => [
    { role: "user",      content: "How do I deal with homesickness after coming back from Canada?" },
    { role: "assistant", content: "Post-exchange adjustment is very real and completely normal! Stay in touch with the friends you made, look through your photos, cook Canadian recipes, and start planning a potential return visit." },
    { role: "user",      content: "How can I keep my English skills sharp now that I'm back in Germany?" },
    { role: "assistant", content: "Watch movies and series in English, read English books, find a language exchange partner, or join an English-speaking club. Follow Canadian social media accounts to stay connected to the culture." }
  ]
}

users.each do |folder, user|
  chat = Chat.create!(user: user)
  (chat_conversations[folder] || []).each do |msg|
    Message.create!(chat: chat, content: msg[:content], role: msg[:role])
  end
end

puts "Created #{Chat.count} chats, #{Message.count} messages"

# -----------------------------
# 5. QUESTIONNAIRES + QUESTIONS
# -----------------------------
# [HW] create_for creates the questionnaire and seeds all 8 predefined questions in one call.
puts "Creating questionnaires and questions..."

questionnaires = users.values.map { |user| Questionnaire.create_for(user) }

puts "Created #{questionnaires.count} questionnaires"

# -----------------------------
# 6. ANSWERS (4 per user, matched to first 4 questions)
# -----------------------------
# [HW] ANSWER_PROFILES: 5 sets of 4 short answers, one per seed user, matched to QUESTIONS order.
# Questions 5-8 are left unanswered so testers can fill them in during demo/testing.
# [HW] zip pairs each question with its matching answer string before creating the Answer record.
ANSWER_PROFILES = [
  [ # User 1
    "The language barrier in the first month was hard. Watching TV without subtitles every evening helped a lot.",
    "Canadians are much more open about emotions than Germans. It made me appreciate both communication styles.",
    "Joining drama club even though I had never acted before taught me I can do things I am not naturally good at.",
    "By the end I was joking in English and dreaming in it — after three months it just started to flow naturally."
  ],
  [ # User 2
    "Making friends was harder than expected. Joining the school soccer team immediately gave me a group and a purpose.",
    "Canada made my hometown feel smaller but more special. I now appreciate Germany's efficiency differently.",
    "Ice camping in January was completely out of my element, but it showed me that vulnerability builds real trust.",
    "I went from speaking English only in class to leading group projects and presenting confidently."
  ],
  [ # User 3
    "Falling behind in maths because the curriculum differed was stressful. A study buddy fixed it quickly.",
    "Surrounded by forests and lakes, I realised how little green space I engage with at home.",
    "Trying surfing despite my fear of deep water taught me that fear is often just unfamiliarity.",
    "By spring I was correcting my own grammar in real time and naturally adjusting my tone to each situation."
  ],
  [ # User 4
    "My host parents spoke very fast. Asking them to slow down felt awkward at first but became a warm daily ritual.",
    "Germans treat silence as comfortable; Canadians treat it as awkward. Knowing this made me a much better listener.",
    "Speaking at the school assembly with shaking legs and getting a standing ovation cured my fear of public speaking.",
    "I went from sounding textbook-formal to using the natural rhythm of a native speaker."
  ],
  [ # User 5
    "A conflict with my host sibling over shared space was tough. Talking it out honestly made us close.",
    "Canada is far more multicultural than home. It changed what 'normal' looks like to me.",
    "Joining a First Nations cultural workshop felt uncomfortable at first but was genuinely eye-opening.",
    "I stopped being afraid of making mistakes in English — that mindset shift helped me in every other area too."
  ]
].freeze

puts "Creating answers..."

questionnaires.each_with_index do |questionnaire, i|
  # [HW] zip pairs each of the first 4 questions with its matching answer string.
  # Questions 5-8 are skipped — left blank for manual testing of the form.
  questionnaire.questions.first(4).zip(ANSWER_PROFILES[i]) do |question, answer_text|
    Answer.create!(question: question, text: answer_text)
  end
end

puts "Created answers for #{questionnaires.count} questionnaires (4 per user)"

# # -----------------------------
# # 8. CHATS
# # -----------------------------
# puts "Creating chats..."

# chats = users.map do |user|
#   Chat.create!(user: user)
# end

# puts "Created #{chats.count} chats"

# ---------------------------
# 9. NOTIFICATIONS
# ---------------------------
puts "Creating notifications..."

# Uses AdminBroadcastNotifier (noticed gem v2) to deliver notifications to all users. MJR
[
  { title: "Welcome to Canada Unique!", message: "Here you can track your tasks, share photos, and connect with your cohort." },
  { title: "Document reminder", message: "Please make sure your Jahreszeugnisse and passport copies are uploaded before your departure date." }
].each do |notif|
  AdminBroadcastNotifier.with(title: notif[:title], message: notif[:message]).deliver(User.all)
end

puts "Created notifications via AdminBroadcastNotifier"

# ---------------------------
# 10. TASKS
# ---------------------------
puts "Importing tasks from Excel..."
TaskImporter.new.call
puts "Imported #{Task.count} tasks"

puts ""
puts "Seeding finished!"
puts "#{User.count} users | #{Photo.count} photos | #{Comment.count} comments | #{Like.count} likes | #{Chat.count} chats | #{Message.count} messages | #{Task.count} tasks (from Excel) | #{Noticed::Event.count} notifications"
