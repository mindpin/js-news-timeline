describe "Base", ->
  event1  = new Event("url1")
  event2  = new Event("url2")
  event3  = new Event("url3")
  person1 = new Persone("p1")
  person2 = new Persone("p2")

  beforeEach ->
    event1.add_person(person1)

  it "url", ->
    expect(t).to.be.ok
