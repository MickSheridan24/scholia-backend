Annotation.destroy_all
User.destroy_all
Study.destroy_all
Category.destroy_all

u = User.create(username: "Test User", password_digest: "fkshgddg")
g = Study.create(name: "Test Study", description: "This study is a test", public_subscribe: true, public_contribute: true)
lit = Category.create(name: "Literature")
phil = Category.create(name: "Philosophy")
hist = Category.create(name: "History")
id = Book.all.first.id

a = Annotation.create(user: u, book_id: id, study: g, title: "This is a test annotation", body: "The book is brothers, the user is user 1, ect.", location_char_index: 1, location_p_index: 10, color: "red", public: true)
a2 = Annotation.create(user: u, book_id: id, study: g, title: "This is a another test annotation", body: "The book is brothers, the user is user 1, ect.", location_char_index: 1, location_p_index: 20, color: "red", public: true)
a3 = Annotation.create(user: u, book_id: id, study: g, title: "Should see all of these in index", body: "The book is brothers, the user is user 1, ect.", location_char_index: 1, location_p_index: 25, color: "red", public: true)
a4 = Annotation.create(user: u, book_id: id, study: g, title: "This one too", body: "The book is common sense, the user is user 1, ect.", location_char_index: 1, location_p_index: 30, color: "red", public: true)

a.categories << lit
a.categories << phil
a2.categories << hist
a2.categories << lit
a3.categories << hist
