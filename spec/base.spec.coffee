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
  describe "add_event(event)", ->
    event1 = new Event(time: new Date(1))
    event2 = new Event(time: new Date(1001))
    event3 = new Event(time: new Date(2001))
    timeline = new Timeline

    it "sorts the order by Event#time", ->
      timeline.add_event(event1)
      timeline.add_event(event3)
      timeline.add_event(event2)

      expect(timeline.events[0]).to.eql(event3)
      expect(timeline.events[1]).to.eql(event2)
      expect(timeline.events[2]).to.eql(event1)

  describe "#persons()", ->
    event1 = new Event(time: new Date(1))
    event2 = new Event(time: new Date(1001))
    event3 = new Event(time: new Date(2001))
    person1 = new Person
    person2 = new Person
    timeline = new Timeline

    person1.add_event(event1)
    person1.add_event(event2)
    person2.add_event(event3)
    [event1, event2, event3].forEach((e)-> timeline.add_event(e))

    it "returns unique collection of persons", ->
      persons = timeline.persons()
      expect(persons).to.have.length(2)
      expect(persons).to.have.members([person1, person2])



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

  describe "linked methods", ->
    event1 = new Event(time: new Date(1))
    event2 = new Event(time: new Date(1001))
    event3 = new Event(time: new Date(2001))
    event4 = new Event
    timeline = new Timeline
    
    [event1, event2, event3].forEach((e)-> timeline.add_event(e))

    it "#prev()", ->
      expect(event2.prev()).to.eql(event3)
      expect(event3.prev()).to.be.undefined
      expect(event4.prev()).to.be.undefined

    it "#next()", ->
      console.log timeline.events, event2.next(), event1
      expect(event2.next()).to.eql(event1)
      expect(event1.next()).to.be.undefined
      expect(event4.next()).to.be.undefined
