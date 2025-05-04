require 'faker'

puts "destroying previous seeds!"

Event.destroy_all
Booking.destroy_all
Post.destroy_all
User.destroy_all
Location.destroy_all

puts "making locations... please wait!"

location1 = Location.create(name: "Noah Studio Meguro", address: "Meguro")
location2 = Location.create(name: "Noah Studio Akihabara", address: "Akihabara")
location3 = Location.create(name: "Noah Studio Shinjuku #2", address: "Shinjuku")
location4 = Location.create(name: "Noah Studio Shinjuku #1", address: "Shinjuku")
location5 = Location.create(name: "Noah Studio Nakameguro", address: "Nakameguro")
location6 = Location.create(name: "Noah Studio Ginza", address: "Ginza")
location7 = Location.create(name: "Girls Bar Moemi", address: "Kabukicho")

puts "there are now #{Location.count} locations, nerds..."

puts "making users who can't wait to move their body"

denis = User.create!(name: "Denis", email: "denis@clownpenis.fart", phone_number: "090-2222-3333", is_teacher: true, description: "I'm a shoe maker for donkeys", password: "123456")
file = File.open("app/assets/images/denis.jpg")
denis.photo.attach(io: file, filename: "denis.jpg", content_type: "image/jpg")
denis.save

mitsuki = User.create!(name: "Mitsuki", email: "mitsuki@email.com", phone_number: "090-2222-3333", is_teacher: true, description: "I'm a popular heels dance teacher", password: "123456")
file = File.open("app/assets/images/mitsuki.jpg")
mitsuki.photo.attach(io: file, filename: "mitsuki.jpg", content_type: "image/jpg")
mitsuki.save

anri = User.create!(name: "Anri", email: "anri@email.com", phone_number: "090-2222-3333", is_teacher: true, description: "I'm a popular jazz hiphop teacher", password: "123456")
file = File.open("app/assets/images/anri.jpg")
anri.photo.attach(io: file, filename: "anri.jpg", content_type: "image/jpg")
anri.save

yann = User.create!(name: "Yann", email: "yann@email.com", phone_number: "090-2222-3333", is_teacher: true, description: "I'm a salsa/tap/tango/zumba/hiphop/ballet/house instructor", password: "123456")
file = File.open("app/assets/images/yann.png")
yann.photo.attach(io: file, filename: "yann.png", content_type: "image/jpg")
yann.save

stuart_student = User.create!(name: "Stuart", email: "stuart@clownpenis.fart", phone_number: "090-2222-3333", is_teacher: false, description: "I want to learn how to prance practically", password: "123456")
file = File.open("app/assets/images/stuart.jpg")
stuart_student.photo.attach(io: file, filename: "stuart.jpg", content_type: "image/jpg")
stuart_student.save

doug_student = User.create!(name: "Doug", email: "doug@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "professional beginner", password: "123456")
file = File.open("app/assets/images/doug.png")
doug_student.photo.attach(io: file, filename: "doug.png", content_type: "image/png")
doug_student.save

celso_student = User.create!(name: "Celso", email: "celso@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/celso1.png")
celso_student.photo.attach(io: file, filename: "celso1.png", content_type: "image/png")
celso_student.save

will = User.create!(name: "Will", email: "will@clownpenis.fart", phone_number: "090-2222-3333", is_teacher: false, description: "ranked 3rd in Meguro belly dance contest 2020, but 1st in 'most sexy dancer'", password: "123456")
file = File.open("app/assets/images/will.png")
will.photo.attach(io: file, filename: "will.png", content_type: "image/png")
will.save

alisa = User.create!(name: "Alisa", email: "alisa@email.com", phone_number: "090-2222-3333", is_teacher: true, description: "I'm a dance teacher and I can code as well too now as well", password: "123456")
file = File.open("app/assets/images/alisa.png")
alisa.photo.attach(io: file, filename: "alisa.png", content_type: "image/png")
alisa.save

bear_student = User.create!(name: "Kumamon", email: "bear@honey.com", phone_number: "090-2222-3333", is_teacher: false, description: "Does you has honey?", password: "123456")
file = File.open("app/assets/images/bear.jpg")
bear_student.photo.attach(io: file, filename: "bear.jpg", content_type: "image/jpg")
bear_student.save

polish = User.create!(name: "Joshel Dovic", email: "bigjd@clownpenis.fart", phone_number: "090-2222-3333", is_teacher: false, description: "Very nice!", password: "123456")
file = File.open("app/assets/images/bartek.jpg")
polish.photo.attach(io: file, filename: "bartek.jpg", content_type: "image/jpg")
polish.save

esteban_student = User.create!(name: "Esteban", email: "esteban@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/001.png")
esteban_student.photo.attach(io: file, filename: "001.png", content_type: "image/png")
esteban_student.save

chafique_student = User.create!(name: "Chafique", email: "chafique@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/002.png")
chafique_student.photo.attach(io: file, filename: "002.png", content_type: "image/png")
chafique_student.save

tristan_student = User.create!(name: "Tristan", email: "tristan@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/003.png")
tristan_student.photo.attach(io: file, filename: "003.png", content_type: "image/png")
tristan_student.save

adam_student = User.create!(name: "Adam", email: "adam@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/004.png")
adam_student.photo.attach(io: file, filename: "004.png", content_type: "image/png")
adam_student.save

roman_student = User.create!(name: "Roman", email: "roman@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/005.png")
roman_student.photo.attach(io: file, filename: "005.png", content_type: "image/png")
roman_student.save

mark_student = User.create!(name: "Mark", email: "mark@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/006.png")
mark_student.photo.attach(io: file, filename: "006.png", content_type: "image/png")
mark_student.save

phyuphyu_student = User.create!(name: "Phyu Phyu", email: "phyuphyu@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/007.png")
phyuphyu_student.photo.attach(io: file, filename: "007.png", content_type: "image/png")
phyuphyu_student.save

mason_student = User.create!(name: "Mason", email: "mason@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/008.png")
mason_student.photo.attach(io: file, filename: "008.png", content_type: "image/png")
mason_student.save

brian_student = User.create!(name: "Brian", email: "brian@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/009.png")
brian_student.photo.attach(io: file, filename: "009.png", content_type: "image/png")
brian_student.save

dylan_student = User.create!(name: "Dylan", email: "dylan@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/010.png")
dylan_student.photo.attach(io: file, filename: "010.png", content_type: "image/png")
dylan_student.save

jarod_student = User.create!(name: "Jarod", email: "jarod@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/012.png")
jarod_student.photo.attach(io: file, filename: "012.png", content_type: "image/png")
jarod_student.save

loris_student = User.create!(name: "Loris", email: "loris@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/013.png")
loris_student.photo.attach(io: file, filename: "013.png", content_type: "image/png")
loris_student.save

claudia_student = User.create!(name: "Claudia", email: "claudia@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/014.png")
claudia_student.photo.attach(io: file, filename: "014.png", content_type: "image/png")
claudia_student.save

toby_student = User.create!(name: "Toby", email: "toby@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/015.png")
toby_student.photo.attach(io: file, filename: "015.png", content_type: "image/png")
toby_student.save

henry_student = User.create!(name: "Henry", email: "henry@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/016.png")
henry_student.photo.attach(io: file, filename: "016.png", content_type: "image/png")
henry_student.save

steven_student = User.create!(name: "Steven", email: "steven@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/017.png")
steven_student.photo.attach(io: file, filename: "017.png", content_type: "image/png")
steven_student.save

christian_student = User.create!(name: "Christian", email: "christian@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/018.png")
christian_student.photo.attach(io: file, filename: "018.png", content_type: "image/png")
christian_student.save

aya_student = User.create!(name: "Aya", email: "aya@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/019.png")
aya_student.photo.attach(io: file, filename: "019.png", content_type: "image/png")
aya_student.save

barry_student = User.create!(name: "Barry", email: "barry@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/020.png")
barry_student.photo.attach(io: file, filename: "020.png", content_type: "image/png")
barry_student.save

chieri_student = User.create!(name: "Chieri", email: "chieri@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/021.png")
chieri_student.photo.attach(io: file, filename: "021.png", content_type: "image/png")
chieri_student.save

eri_student = User.create!(name: "Eri", email: "eri@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/022.png")
eri_student.photo.attach(io: file, filename: "022.png", content_type: "image/png")
eri_student.save

gary_student = User.create!(name: "Gary", email: "gary@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/023.png")
gary_student.photo.attach(io: file, filename: "023.png", content_type: "image/png")
gary_student.save

james_student = User.create!(name: "James", email: "james@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/024.png")
james_student.photo.attach(io: file, filename: "024.png", content_type: "image/png")
james_student.save

noemi_student = User.create!(name: "Noemi", email: "noemi@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/025.png")
noemi_student.photo.attach(io: file, filename: "025.png", content_type: "image/png")
noemi_student.save

sasha_student = User.create!(name: "Sasha", email: "sasha@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/026.png")
sasha_student.photo.attach(io: file, filename: "026.png", content_type: "image/png")
sasha_student.save

trouni_student = User.create!(name: "Trouni", email: "trouni@email.com", phone_number: "090-2222-3333", is_teacher: false, description: "Always dreamed of dancing in Swan Lake", password: "123456")
file = File.open("app/assets/images/027.png")
trouni_student.photo.attach(io: file, filename: "027.png", content_type: "image/png")
trouni_student.save

users = [aya_student, barry_student, chieri_student, eri_student, gary_student, james_student, noemi_student, sasha_student, trouni_student, phyuphyu_student, mason_student, brian_student, dylan_student, jarod_student, loris_student, claudia_student, toby_student, henry_student, steven_student, christian_student, mark_student, roman_student, adam_student, tristan_student, chafique_student, esteban_student, stuart_student, doug_student, celso_student, will, alisa, denis, mitsuki, anri, polish, bear_student]

n = 0
while n < 10
  newuser= User.create!(name: "#{Faker::Name.name}", email: "#{Faker::Name.first_name}+#{rand(1..2500)}@mail.com", phone_number: "090-2222-3333", is_teacher: false, description: "#{Faker::Quote.mitch_hedberg}", password: "123456")
  file = File.open("app/assets/images/unknownpic.jpg")
  newuser.photo.attach(io: file, filename: "unknownpic.jpg", content_type: "image/jpg")
  newuser.save
  users.push(User.last)
  n += 1
end

puts "there are now #{User.count} users, aka losers..."
puts "let's make some events..."

event1 = Event.create!(title: "Professional Salsa", description: "Spice up your life with our salsa classes! Enjoy the lively rhythms and passionate movements of this Latin dance.", user: denis, start_date: Date.today + 9, end_date: (Date.today + 10), location: location1, capacity: 10, price: 1100)
file = File.open("app/assets/images/hh1.jpg")
event1.photos.attach(io: file, filename: "hh1.jpg", content_type: "image/jpg")
event1.save

event2 = Event.create!(title: "Heels Beginners", description: "Delicious Dances - make desserts while twerking", user: mitsuki, start_date: Date.today + 1, end_date: (Date.today + 2), location: location4, capacity: 10, price: 800)
file = File.open("app/assets/images/hh2.jpg")
event2.photos.attach(io: file, filename: "hh14.jpg", content_type: "image/jpg")
event2.save

event3 = Event.create!(title: "Salsa 101", description: "Salsa class for beginners", user: denis, start_date: Date.today, end_date: (Date.today + 1), location: location5, capacity: 22, price: 1500)
file = File.open("app/assets/images/hh3.jpg")
event3.photos.attach(io: file, filename: "hh3.jpg", content_type: "image/jpg")
event3.save

event4 = Event.create!(title: "Salsa 202", description: "Salsa class for beginners", user: yann, start_date: Date.today, end_date: (Date.today + 1), location: location2, capacity: 8, price: 1000)
file = File.open("app/assets/images/hh4.jpg")
event4.photos.attach(io: file, filename: "hh4.jpg", content_type: "image/jpg")
event4.save

event5 = Event.create!(title: "Ballroom", description: "Elegance and grace await in our ballroom dance class. Learn classic dances like the waltz, foxtrot, and tango.", user: yann, start_date: Date.today, end_date: (Date.today + 1), location: location3, capacity: 22, price: 900)
file = File.open("app/assets/images/hh5.jpg")
event5.photos.attach(io: file, filename: "hh5.jpg", content_type: "image/jpg")
event5.save

event6 = Event.create!(title: "Belly Dance", description: "Embrace the art of belly dance! Our classes focus on fluid movements and isolations, perfect for improving core strength and flexibility.", user: yann, start_date: Date.today, end_date: (Date.today + 1), location: location2, capacity: 15, price: 1100)
file = File.open("app/assets/images/hh6.jpg")
event6.photos.attach(io: file, filename: "hh6.jpg", content_type: "image/jpg")
event6.save

event7 = Event.create!(title: "Heels advanced", description: "Continue on your heels journey", user: mitsuki, start_date: Date.today + 6, end_date: (Date.today + 7), location: location2, capacity: 12, price: 1000)
file = File.open("app/assets/images/hh7.jpg")
event7.photos.attach(io: file, filename: "hh7.jpg", content_type: "image/jpg")
event7.save
event8 = Event.create!(title: "Pinnacle of Prance", description: "You'll have a goddamn doctorate in prancing, pantsed or no", user: denis, start_date: Date.today + 2, end_date: (Date.today + 3), location: location3, capacity: 22, price: 900)
file = File.open("app/assets/images/hh8.jpg")
event8.photos.attach(io: file, filename: "hh8.jpg", content_type: "image/jpg")
event8.save

event9 = Event.create!(title: "Slip and Slide", description: "The way of water, if water was a way", user: yann, start_date: Date.today + 3, end_date: (Date.today + 4), location: location2, capacity: 12, price: 1100)
file = File.open("app/assets/images/hh9.jpg")
event9.photos.attach(io: file, filename: "hh9.jpg", content_type: "image/jpg")
event9.save

event10 = Event.create!(title: "Contemporary", description: "Explore creativity and emotion in our contemporary dance class. Combine elements of ballet, modern, and jazz for a unique dance experience.", user: mitsuki, start_date: Date.today, end_date: (Date.today + 1), location: location3, capacity: 6, price: 1200)
file = File.open("app/assets/images/hh10.jpg")
event10.photos.attach(io: file, filename: "hh10.jpg", content_type: "image/jpg")
event10.save

event11 = Event.create!(title: "Breakdance", description: "Join our breakdance class and master the art of b-boying and b-girling. Learn power moves, freezes, and top rocks in a supportive environment.", user: anri, start_date: Date.today + 5, end_date: (Date.today + 6), location: location6, capacity: 14, price: 2000)
file = File.open("app/assets/images/hh11.jpg")
event11.photos.attach(io: file, filename: "hh11.jpg", content_type: "image/jpg")
event11.save

event12 = Event.create!(title: "Heels Advanced", description: "Like hot yoga, but you're only wearing very high heels. Warning: we will be sharing one pole", user: anri, start_date: Date.today + 8, end_date: (Date.today + 9), location: location7, capacity: 4, price: 3000)
file = File.open("app/assets/images/hh12.jpg")
event12.photos.attach(io: file, filename: "hh12.jpg", content_type: "image/jpg")

event12.save
event13 = Event.create!(title: "Polka intensive", description: "Free your mind and discover the beauty of Central Europe.", user: denis, start_date: Date.today + 9, end_date: (Date.today + 10), location: location1, capacity: 5, price: 3000)
file = File.open("app/assets/images/hh13.jpg")
event13.photos.attach(io: file, filename: "hh13.jpg", content_type: "image/jpg")
event13.save

event14 = Event.create!(title: "Breakdance", description: "Join our breakdance class and master the art of b-boying and b-girling. Learn power moves, freezes, and top rocks in a supportive environment.", user: anri, start_date: Date.today + 5, end_date: (Date.today + 6), location: location6, capacity: 14, price: 2000)
file = File.open("app/assets/images/hh14.jpg")
event14.photos.attach(io: file, filename: "hh14.jpg", content_type: "image/jpg")
event14.save

event15 = Event.create!(title: "Heels Advanced", description: "Like hot yoga, but you're only wearing very high heels. Warning: we will be sharing one pole", user: anri, start_date: Date.today + 8, end_date: (Date.today + 9), location: location7, capacity: 4, price: 3000)
file = File.open("app/assets/images/hh13.jpg")
event15.photos.attach(io: file, filename: "hh13.jpg", content_type: "image/jpg")
event15.save

event16 = Event.create!(title: "Polka intensive", description: "Free your mind and discover the beauty of Central Europe.", user: yann, start_date: Date.today + 9, end_date: (Date.today + 10), location: location1, capacity: 5, price: 3000)
file = File.open("app/assets/images/hh16.jpg")
event16.photos.attach(io: file, filename: "hh16.jpg", content_type: "image/jpg")
event16.save

# past events for Alisa
event17 = Event.create!(title: "Heels Beginner", description: "Walking techniques and simple choreography", user: alisa, start_date: DateTime.new(2024,11,27,18,30), end_date: DateTime.new(2024,11,27,19,30), location: location1, capacity: 30, price: 3000)
file = File.open("app/assets/images/hh14.jpg")
event17.photos.attach(io: file, filename: "hh14.jpg", content_type: "image/jpg")
event17.save

event18 = Event.create!(title: "Polish dance", description: "Walking techniques and simple choreography", user: alisa, start_date: DateTime.new(2024,11,16,19,30), end_date: DateTime.new(2024,11,16,20,30), location: location2, capacity: 15, price: 3000)
file = File.open("app/assets/images/dance.jpg")
event18.photos.attach(io: file, filename: "dance.jpg", content_type: "image/jpg")
event18.save

event20 = Event.create!(title: "Heels Advanced", description: "Across the floor exercises and choreography", user: alisa, start_date: DateTime.new(2024,11,19,19,30), end_date: DateTime.new(2024,11,19,20,30), location: location1, capacity: 30, price: 3000)
file = File.open("app/assets/images/hh13.jpg")
event20.photos.attach(io: file, filename: "hh13.jpg", content_type: "image/jpg")
event20.save

event21 = Event.create!(title: "Heels Beginner", description: "Walking techniques and simple choreography", user: alisa, start_date: DateTime.new(2024,12,22,18,30), end_date: DateTime.new(2024,12,22,19,30), location: location1, capacity: 30, price: 3000)
file = File.open("app/assets/images/hh14.jpg")
event21.photos.attach(io: file, filename: "hh14.jpg", content_type: "image/jpg")
event21.save

event22 = Event.create!(title: "Heels Advanced", description: "Walking techniques and simple choreography", user: alisa, start_date: DateTime.new(2024,11,15,18,30), end_date: DateTime.new(2024,11,15,19,30), location: location2, capacity: 30, price: 3000)
file = File.open("app/assets/images/hh13.jpg")
event22.photos.attach(io: file, filename: "hh13.jpg", content_type: "image/jpg")
event22.save

event23 = Event.create!(title: "Heels Advanced", description: "Walking techniques and simple choreography", user: alisa, start_date: DateTime.new(2024,11,22,18,30), end_date: DateTime.new(2024,11,22,19,30), location: location2, capacity: 30, price: 3000)
file = File.open("app/assets/images/hh13.jpg")
event23.photos.attach(io: file, filename: "hh13.jpg", content_type: "image/jpg")
event23.save

event24 = Event.create!(title: "Polish dance", description: "Walking techniques and simple choreography", user: alisa, start_date: DateTime.new(2024,11,6,19,30), end_date: DateTime.new(2024,11,6,20,30), location: location2, capacity: 15, price: 3000)
file = File.open("app/assets/images/dance.jpg")
event24.photos.attach(io: file, filename: "dance.jpg", content_type: "image/jpg")
event24.save

event25 = Event.create!(title: "Polish dance", description: "Walking techniques and simple choreography", user: alisa, start_date: DateTime.new(2024,11,13,19,30), end_date: DateTime.new(2024,11,13,20,30), location: location2, capacity: 15, price: 3000)
file = File.open("app/assets/images/dance.jpg")
event25.photos.attach(io: file, filename: "dance.jpg", content_type: "image/jpg")
event25.save

puts "there are now #{Event.count} events as well"

puts "cool. so. how about some bookings..."

events = [event1, event2, event3, event4, event5, event6, event7, event8, event9, event10, event11, event12, event13]
states = ["pending", "paid"]

events.each do |event|
  random_count = rand(3..25)
  p event.user.name
  temp_users = users.reject { |h| h["name"] == "#{event.user.name}" }
  selected_users = temp_users.sample(random_count)
    selected_users.each do |user|
    selected_state = states.sample
    Booking.create!(state: selected_state, checkout_session_id: "indecypherable id", event: event, user: user)
  end
end

# bookings for Alisa's past events
[event17].each do |event|
  # random_count = rand(3..25)
  p event.user.name
  temp_users = users.reject { |h| h["name"] == "#{event.user.name}" }
  selected_users = temp_users.sample(35)
    selected_users.each do |user|
    Booking.create!(state: "paid", event: event, user: user)
    end
  end

  [event18].each do |event|
    # random_count = rand(3..25)
    p event.user.name
    temp_users = users.reject { |h| h["name"] == "#{event.user.name}" }
    selected_users = temp_users.sample(10)
      selected_users.each do |user|
      Booking.create!(state: "paid", event: event, user: user)
      end
    end

    [event21].each do |event|
      # random_count = rand(3..25)
      p event.user.name
      temp_users = users.reject { |h| h["name"] == "#{event.user.name}" }
      selected_users = temp_users.sample(15)
        selected_users.each do |user|
        Booking.create!(state: "paid", event: event, user: user)
        end
      end

    [event22].each do |event|
      # random_count = rand(3..25)
      p event.user.name
      temp_users = users.reject { |h| h["name"] == "#{event.user.name}" }
      selected_users = temp_users.sample(35)
        selected_users.each do |user|
        Booking.create!(state: "paid", event: event, user: user)
        end
      end

      [event23].each do |event|
        # random_count = rand(3..25)
        p event.user.name
        temp_users = users.reject { |h| h["name"] == "#{event.user.name}" }
        selected_users = temp_users.sample(33)
          selected_users.each do |user|
          Booking.create!(state: "paid", event: event, user: user)
          end
      end

      [event24].each do |event|
        # random_count = rand(3..25)
        p event.user.name
        temp_users = users.reject { |h| h["name"] == "#{event.user.name}" }
        selected_users = temp_users.sample(8)
          selected_users.each do |user|
          Booking.create!(state: "paid", event: event, user: user)
          end
      end

      [event25].each do |event|
        # random_count = rand(3..25)
        p event.user.name
        temp_users = users.reject { |h| h["name"] == "#{event.user.name}" }
        selected_users = temp_users.sample(7)
          selected_users.each do |user|
          Booking.create!(state: "paid", event: event, user: user)
          end
      end

puts "there are now #{Booking.count} bookings as well now as well, too"
