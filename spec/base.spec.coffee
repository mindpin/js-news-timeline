describe "Array", ->
  describe ".slice(argsobj)", ->
    argsobj = (()-> arguments)(1, 2, 3, 4)

    it "creates an array from an arguments object", ->
      result = Array.slice(argsobj)
      expect(argsobj).not.to.be.an("array")
      expect(result).to.be.an("array")
      expect(result).to.eql([1, 2, 3, 4])

  describe "#flatten()", ->
    array = [1, [2], [3, 4]]

    it "flattens the array", ->
      result = array.flatten()
      expect(result).to.eql([1, 2, 3, 4])
      
  describe "#uniq()", ->
    array = [1, 1, 1, 2, 2, 2, 3, 4, 3, 5]

    it "creates an array only contain uniq values", ->
      result = array.uniq()
      expect(result).to.eql([1, 2, 3, 4, 5])

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
  describe "#add_event(event)", ->
    event1 = new Event(time: new Date(1), id:1)
    event2 = new Event(time: new Date(1001), id:2)
    event3 = new Event(time: new Date(2001), id:3)
    timeline = new Timeline

    it "sorts the order by Event#time", ->
      timeline.add_event(event1)
      timeline.add_event(event3)
      timeline.add_event(event2)

      expect(timeline.events[0]).to.eql(event3)
      expect(timeline.events[1]).to.eql(event2)
      expect(timeline.events[2]).to.eql(event1)

  describe "#find_person(name)", ->
    event1 = new Event(time: new Date(1))
    event2 = new Event(time: new Date(1001))
    event3 = new Event(time: new Date(2001))
    event4 = new Event(time: new Date(3001))
    person1 = new Person(name: "p1")
    person2 = new Person(name: "p2")
    person3 = new Person(name: "p3")
    timeline = new Timeline

    person1.add_event(event1)
    person1.add_event(event2)
    person2.add_event(event3)
    person3.add_event(event4)
    [event1, event2, event3, event4].forEach((e)-> timeline.add_event(e))

    it "fetches person by name", ->
      expect(timeline.find_person("p2")).to.be.eql(person2)
      expect(timeline.find_person("p4")).to.be.undefined

  describe "select methods", ->
    event1 = new Event(time: new Date(1), id: 1)
    event2 = new Event(time: new Date(1001), id: 2)
    event3 = new Event(time: new Date(2001), id: 3)
    event4 = new Event(time: new Date(3001), id: 4)
    event5 = new Event(time: new Date(4001), id: 5)
    event6 = new Event(time: new Date(5001), id: 6)
    person1 = new Person
    person2 = new Person
    person3 = new Person
    timeline = new Timeline

    person1.add_event(event1)
    person1.add_event(event2)
    person2.add_event(event3)
    person3.add_event(event4)
    [person1, person2].forEach((p)-> p.add(event5))
    [person1, person2, person3].forEach((p)-> p.add(event6))
    [event1, event2, event3, event4, event5, event6].forEach((e)-> timeline.add_event(e))    

    describe "#events_except(person1 [, person2, person3, ...])", ->
      it "fetches all the contained events except persons'", ->
        result1 = timeline.events_except(person1)
        result2 = timeline.events_except(person2, person3)
        expect(timeline.events).to.have.length(6)
        expect(result1).to.have.length(2)
        expect(result1).to.have.members([event3, event4])
        expect(result2).to.have.members([event1, event2])
        
    describe "#events_only(person1 [, person2, person3, ...])", ->
      it "fetches events only persons' events", ->
        result1 = timeline.events_only(person1)
        result2 = timeline.events_only(person2, person3)
        expect(timeline.events).to.have.length(6)
        expect(result1).to.have.length(4)
        expect(result1).to.have.members([event1, event2, event5, event6])
        expect(result2).to.have.members([event3, event4, event5, event6])
      
    describe "#common_events(person [, person2, person3, ...])", ->
      it "fetches events from persons events intersection", ->
        result1 = timeline.common_events(person1, person2, person3)
        result2 = timeline.common_events(person1, person2)
        expect(result1).to.have.members([event6])
        expect(result2).to.have.members([event5, event6])

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

    describe "#prev()", ->
      it "fetches previous event if present", ->
        expect(event2.prev).to.eql(event3)
        expect(event3.prev).to.be.undefined
        expect(event4.prev).to.be.undefined

    describe "#next()", ->
      it "fetches next event if present", ->
        expect(event2.next).to.eql(event1)
        expect(event1.next).to.be.undefined
        expect(event4.next).to.be.undefined

describe "ImageRow", ->
  describe "#add_image(urls)", ->
    person = new Person
    event  = new Event

    it "adds image into images", ->
      person.add_image("1", "2", "3")
      event.add_image("4", "5", "6")
      expect(event.images).to.have.members(["4", "5", "6"])
      expect(person.images).to.have.members(["1", "2", "3"])
