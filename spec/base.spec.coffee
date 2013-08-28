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
    
describe "Timeline", ->
  timeline = new Timeline

  describe "add_event(event)", ->
    event1 = new Event(time: new Date(1))
    event2 = new Event(time: new Date(1001))
    event3 = new Event(time: new Date(2001))

    it "sorts the order by Event#time", ->
      timeline.add_event(event1)
      timeline.add_event(event3)
      timeline.add_event(event2)

      expect(timeline.events[0]).to.eql(event3)
      expect(timeline.events[1]).to.eql(event2)
      expect(timeline.events[2]).to.eql(event1)


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
