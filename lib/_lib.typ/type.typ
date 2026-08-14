#let MetaData(
  id: none,
  parent_id: none,
  title: none,
  authors: (),
  date: datetime.today(),
  keywords: (),
  description: "",
  abstract: "",
  tag: (),
  category: none,
  ..obj,
) = {
  assert.eq(type(id), str, message: "The id must be a string")
  assert.eq(type(parent_id), str, message: "The parent_id must be a string")
  assert.eq(type(title), content, message: "The title must be a content")
  assert.eq(type(authors), array, message: "The id must be an array")
  assert(authors.all(x => type(x) == content), message: "The id must be an array of content")
  assert.eq(type(date), datetime, message: "The id must be a datetime")
  assert.eq(type(keywords), array, message: "The id must be a array")
  assert(keywords.all(x => type(x) == str), message: "The id must be an array of string")
  assert.eq(type(description), array, message: "The id must be a string")
  assert.eq(type(keywords), array, message: "The id must be a string")
  assert.eq(type(keywords), array, message: "The id must be a string")
  assert.eq(type(keywords), array, message: "The id must be a string")
  assert.eq(type(keywords), array, message: "The id must be a string")
  assert.eq(type(keywords), array, message: "The id must be a string")
  ()
}
