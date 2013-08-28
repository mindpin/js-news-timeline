describe "Base", ->
  class FooBar extends Base

  bar     = "bar"
  foo_bar = new FooBar(bar: bar)

  describe "#class_name()", ->
    it "returns lowercase underscored string name for FooBar", ->
      expect(foo_bar.class_name()).to.eql("foo_bar")

  describe "#constructor(args)", ->
    it "merges args object's properties into foo_bar", ->
      expect(foo_bar.bar).to.eql(bar)
    

describe "Event", ->
  describe "#add_person(person)", ->
    event1  = new Event
    person1 = new Person
    person2 = new Person

    it "adds person to Event#persons", ->
      event1.add_person(person1)
      expect(event1.persons).to.include(person1)
      expect(event1.persons).to.have.length(1)

      event1.add_person(person1)
      expect(event1.persons).to.have.length(1)

      event1.add_person(person2)
      expect(event1.persons).to.have.length(2)
      expect(event1.persons).to.include.members([person1, person2])

    it "hei", ->
      console.log event1
