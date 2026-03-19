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
# Noticed gem stores notifications here; must be cleared before destroying users. MJR
Noticed::Notification.destroy_all
Noticed::Event.destroy_all
# Raw SQL to clear the notifications table since there is no Notification model. MJR
ActiveRecord::Base.connection.execute("DELETE FROM notifications")
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

# Create one fixed admin user for easy login during development. MJR
admin = User.create!(
  email: "admin@test.com",
  password: "123456", # changed from "password" to match project standard. MJR
  name: "Admin User",
  role: "admin", # assigned admin role so this user can manage notifications and users. MJR
  batch_number: Date.current.year,
  program_duration: PROGRAM_DURATIONS.sample,
  departure_date: Date.today + rand(30..60),
  status: STATUSES.sample
)

# Create one fixed viewer user to test read-only access. MJR
viewer = User.create!(
  email: "viewer@test.com",
  password: "123456", # changed from "password" to match project standard. MJR
  name: "Viewer User",
  role: "viewer", # assigned viewer role so this user can only read. MJR
  batch_number: Date.current.year,
  program_duration: PROGRAM_DURATIONS.sample,
  departure_date: Date.today + rand(30..60),
  status: STATUSES.sample
)

# Create 5 regular student users with randomised data. MJR
students = 5.times.map do
  User.create!(
    email: Faker::Internet.unique.email,
    password: "123456", # changed from "password" to match project standard. MJR
    name: Faker::Name.name,
    role: "student", # explicitly set student role instead of relying on the default. MJR
    batch_number: Date.current.year,
    program_duration: PROGRAM_DURATIONS.sample,
    departure_date: Date.today + rand(30..60),
    status: STATUSES.sample
  )
end

# Combine all users into one array for use in associations below. MJR
users = [admin, viewer] + students

puts "Created #{users.count} users (1 admin, 1 viewer, #{students.count} students)"

# ---------------------------
# 2. PHOTOS
# ---------------------------
puts "Creating photos..."

photos = 10.times.map do
  Photo.create!(
    description: Faker::Lorem.sentence,
    photo: Faker::LoremFlickr.image(size: "300x300"),
    user: users.sample
  )
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

likes = 20.times.map do
  Like.create!(
    user: users.sample,
    photo: photos.sample
  )
end

puts "Created #{likes.count} likes"

# -----------------------------
# 5. QUESTIONNAIRES
# -----------------------------
puts "Creating questionnaires..."

questionnaires = users.map do |user|
  Questionnaire.create!(
    user: user,
    ai_summary: Faker::Lorem.paragraph
  )
end

puts "Created #{questionnaires.count} questionnaires"

# -----------------------------
# 6. QUESTIONS
# -----------------------------
puts "Creating questions..."

questions = questionnaires.flat_map do |questionnaire|
  3.times.map do
    Question.create!(
      text: Faker::Lorem.question,
      questionnaire: questionnaire
    )
  end
end

# flat_map = map + flatten (1 level)
#   runs .map on each element
#   merges all nested arrays into one single array

puts "Created #{questions.count} questions"

# -----------------------------
# 7. ANSWERS
# -----------------------------
puts "Creating answers..."

answers = questions.map do |question|
  Answer.create!(
    text: Faker::Lorem.sentence,
    question: question
  )
end

puts "Created #{answers.count} answers"

# -----------------------------
# 8. CHATS
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

tasks = 10.times.map do
  Task.create!(
    description: Faker::Lorem.sentence,
    status: ["pending", "done"].sample,
    user: users.sample
  )
end

puts "Created #{tasks.count} tasks"

# Confirm result with success message

puts "Seeding finished 🎉"
puts "#{User.count} users, #{Photo.count} photos, #{Comment.count} comments created."
