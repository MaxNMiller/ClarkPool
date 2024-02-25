import datetime
import copy
from geopy.geocoders import Nominatim
geolocator = Nominatim(user_agent="deez")
#the quick brown fox jumps over the lazy dog

userList = []

# Add a user to userList while maintaining alphabetical order
def addUser(newUser):
        if userList.count == 0:
            userList.append(newUser)
        else:
            for i, existingUser in enumerate(userList):
                if newUser.upper < existingUser.upper():
                    userList.insert(i, newUser)
                    break
            
class Trip:
    def __init__(self, driver, startLocation, destination, startTime):
        self.startTime = startTime
        self.rideRequests = []  #list of all active requests
        self.inCar = []    #list of all active riders in the carpool
        self.riders = []
        self.driver = driver
        self.startLocation = startLocation
        self.destination = destination
        
    def __repr__(self):
        return str([self.startTime.strftime("%Y-%m-%d %H:%M:%S"),"Driver: ", self.driver ,"Riders: ", self.inCar])
    
    def getStartTime(self):
        return self.startTime
    
    def addRider(self, rider):
        #adds a rider to the trip
        self.inCar.append(rider)
        self.riders.append(rider)

    def startTrip(self):
        driver.currentTrip = self
        for rider in self.inCar:
            rider.currentTrip = self

    def endTrip(self):
        for rider in self.inCar:
            rider.tripHistory.append(TripRecord(self, rider))
       
        self.driver.tripHistory.append(TripRecord(self, rider))
    def print(self):
        print("Driver: " + str(driver.username))
        for i, rider in enumerate(self.riders):
            print("Rider " + str(i+1) + ": " + rider.username)
        print("Start Location: " + str(self.startLocation))
        print("End Location: " + str(self.destination))
        print("Start Time: " + str(self.startTime.hour) + ":", end="")
        if self.startTime.minute < 10:
            print("0", end="")
        print(str(self.startTime.minute), end="")
        print(" on " + str(self.startTime.month) + "/" + str(self.startTime.day) + "/" + str(self.startTime.year))
        
class Account:
    def __init__(self, username, driver):
        self.username = username
        self.tripHistory = [] # List of completed trips
        self.plannedTrips = [] # List of future trips
        self.currentTrip = None
        self.path = 'placeholder'
        self.stopTime = None
        self.isDriver = driver
        addUser(self)

    def __repr__(self):
        return str([self.path, self.username])
    
    def setIsDriver(self, driver):
        self.isDriver = driver

    #called when a driver account creates a new trip
    def newDriverTrip(self):
        #gets the gps location from the user
        startLocation = geolocator.geocode(input("Enter Start Location: "))
        destination = geolocator.geocode(input("Enter Driver Destination: "))
        #gets the time
        startTime = datetime.datetime.now()

        #creates a new trip with all the parameters
        thisTrip = Trip(self, startLocation, destination, startTime)

        #adds the current trip to a list of planned trips (trips that aren't archived)
        self.plannedTrips.append(thisTrip)
        return thisTrip


    #called when a rider requests to join a driver's trip
    def riderTripRequest(self, trip):
        #gets the gps location from the user
        #destination = geolocator.geocode(input("Enter Rider Destination: "))
        #self.currentTrip = destination
        destination = "Placeholder"
        self.currentTrip = "Placeholder"

        #appends the rider's request to a list of requests the driver can accept or deny
        trip.rideRequests.append((self.username , destination))


    def acceptRequest(self, trip: Trip, rider):
        #adds the rider to the trip, and removes their request
        trip.addRider(rider)
        #fullTrip = copy.deepcopy(trip)
        trip.rideRequests.remove((rider.username, rider.currentTrip))
        #return fullTrip
    

    def denyRequest(self, trip: Trip, rider):
        #removes the rider's request without adding them to the trip
        trip.rideRequests.remove((rider.username, rider.currentTrip))


    def requestFulfilled(self, trip: Trip):
        #finishes the trip for one rider and saves it in his history
        self.stopTime = datetime.datetime.now()
        #ends the trip once the driver is done
        if self.isDriver: 
            trip.endTrip() 
        else:
            self.tripHistory.append(TripRecord(trip, self))
            trip.inCar.remove(self)


class TripRecord:
    def __init__(self, trip: Trip, account: Account):
        self.startTime = trip.startTime
        self.endTime = datetime.datetime.now()
        self.inCar = trip.inCar
        self.driver = trip.driver
        self.startLocation = trip.startLocation
        self.destination = trip.destination
        self.isDriver = account.isDriver
       
    def __repr__(self):
        return "Trip from " + str(self.startLocation) + " at " + str(self.startTime) + " to " + str(self.destination) + " at " + str(self.endTime)
            
#creates the driver and rider accounts
driver = Account("Milo", True)
rider1 = Account("Max", False)
rider2 = Account("Charlie", False)
rider3 = Account("Scott Gurney", False)

trip = driver.newDriverTrip()

rider1.riderTripRequest(trip)
rider2.riderTripRequest(trip)
rider3.riderTripRequest(trip)

print(trip.rideRequests)

#since all requests are accepted, the riderequests list is now empty
driver.acceptRequest(trip, rider1)
driver.acceptRequest(trip, rider2)
driver.acceptRequest(trip, rider3)
print(trip.rideRequests)
print(trip.inCar)
rider3.requestFulfilled(trip)
print(rider3.tripHistory[0])
print(trip.inCar)
print("\n\n")
trip.print()