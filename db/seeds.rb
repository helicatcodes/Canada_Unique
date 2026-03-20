# NOTES
# - order matters
#     destroy children → destroy parents
#     create parents → create children
# - associations > IDs -->cleaner and safer
#     instead of: user_id: users.sample.id
#     use: user: users.sample


# Clean the database (to avoid du)

puts "Cleaning database..."
Like.destroy_all
Comment.destroy_all
Photo.destroy_all
Answer.destroy_all
Question.destroy_all
Questionnaire.destroy_all
Notification.destroy_all
Task.destroy_all
Message.destroy_all
Chat.destroy_all
User.destroy_all

puts "Database cleaned ✅..."

# Create instances for each model including proper associations

# ---------------------------
# 1. USERS
# ---------------------------
puts "Creating users..."

STATUSES = %w[pre_flight in_canada post_canada]
PROGRAM_DURATIONS = [5, 10]

users = 5.times.map do
  User.create!(
  email: Faker::Internet.unique.email,
  password: "password",
  name: Faker::Name.name,
  batch_number: Date.current.year,
  program_duration: PROGRAM_DURATIONS.sample,
  departure_date: Date.today + rand(30..60),
  status: STATUSES.sample
  )
end

puts "Created #{users.count} users"

# ---------------------------
# 2. PHOTOS
# ---------------------------
puts "Creating photos..."

require "open-uri"

photos = users.flat_map do |user|
  3.times.map do
    photo = Photo.create!(
      description: Faker::Lorem.sentence,
      user: user
    )
    photo.image.attach(
      io: URI.open(Faker::LoremFlickr.image(size: "300x300", search_terms: ["canada"])),
      filename: "photo_#{photo.id}.jpg",
      content_type: "image/jpeg"
    )
    photo
  end
end

puts "Created #{photos.count} photos"

# -----------------------------
# 3. COMMENTS
# -----------------------------
puts "Creating comments..."

comments = 15.times.map do
  Comment.create!(
    text: Faker::Lorem.sentence,
    user: users.sample,
    photo: photos.sample
  )
end

puts "Created #{comments.count} comments"

# -----------------------------
# 4. LIKES
# -----------------------------
# do we need to create likes in advance?
puts "Creating likes..."

# [HW] Temporary fix for testing — find_or_create_by avoids a uniqueness crash when
# random sampling picks the same user+photo pair more than once.
# This can be reverted/replaced once Mario's seed merge covers the likes section.
likes = 20.times.map do
  Like.find_or_create_by(
    user: users.sample,
    photo: photos.sample
  )
end

puts "Created #{likes.count} likes"

# -----------------------------
# 5. QUESTIONNAIRES + QUESTIONS
# -----------------------------
# [HW] create_for creates the questionnaire and seeds all 8 predefined questions in one call.
puts "Creating questionnaires and questions..."

questionnaires = users.map { |user| Questionnaire.create_for(user) }

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

# -----------------------------
# 8. NOTIFICATIONS
# -----------------------------
 puts "Creating notifications..."

 notifications = 10.times.map do
   Notification.create!(
     content: Faker::Lorem.sentence,
     user: users.sample,
     date_time: Faker::Time.forward(days: 5)
   )
 end

puts "Created #{notifications.count} notifications"

# -----------------------------
# 9. CHATS
# -----------------------------
puts "Creating chats..."

chats = users.map do |user|
  Chat.create!(user: user)
end

puts "Created #{chats.count} chats"

# -----------------------------
# 10. MESSAGES
# -----------------------------
puts "Creating messages..."

messages = chats.flat_map do |chat|
  3.times.map do
    Message.create!(
      chat: chat,
      content: Faker::Lorem.sentence,
      role: ["user", "assistant"].sample
    )
  end
end

puts "Created #{messages.count} messages"

# -----------------------------
# 11. TASKS
# -----------------------------
puts "Creating tasks..."

obligatory_tasks = [
  "Jahreszeugnisse",
  "Gastfamilienbrief",
  "Fotocollage",
  "Recommendation Form",
  "Reisepass",
  "Passbild",
  "Personalausweise deiner Eltern",
  "(Internationale) Geburtsurkunde",
  "Impfpass",
  "Medizinische Einschränkungen",
  "Application",
  "Custodianship Declaration",
  "Letter of Acceptance",
  "Visum",
  "Sonstige"
]
users.each do |user|
  obligatory_tasks.each do |task|
    Task.create!(
      description: Faker::Lorem.sentence,
      name: task,
      obligatory: true,
      start_date: Date.tomorrow+rand(10..20),
      user: user,
      status: ["offen", "in Bearbeitung", "erledigt"].sample
    )
  end
end

fun_tasks = [
  "Packing list",
  "Resources about location"
]
users.each do |user|
  fun_tasks.each do |task|
    Task.create!(
      description: Faker::Lorem.sentence,
      name: task,
      obligatory: false,
      start_date: Date.tomorrow+rand(10..20),
      user: user,
      status: ["offen", "in Bearbeitung", "erledigt"].sample
    )
  end
end

puts "Created #{Task.count} tasks"

# Confirm result with success message

puts "Seeding finished 🎉"
puts "#{User.count} users, #{Photo.count} photos, #{Comment.count} comments created."
