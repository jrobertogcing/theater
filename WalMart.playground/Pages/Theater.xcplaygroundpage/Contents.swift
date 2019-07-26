//: Playground -Jose Roberto González Castañeda

import UIKit
import Foundation
import PlaygroundSupport

//Line just for use Timer() y playground
PlaygroundPage.current.needsIndefiniteExecution = true

/*
Implement a simple ticket service that facilitates the discovery, temporary hold, and final reservation of seats within a high-demand performance venue.
 
 ·Find the number of seats available within the venue
 Note: available seats are seats that are neither held nor reserved.
 
 ·Find and hold the best available seats on behalf of a customer
 Note: each ticket hold should expire within a set number of seconds.
 
 ·Reserve and commit a specific group of held seats for a customer
 
 */

/*
 
 public interface TicketService {
 
 /**
 * The number of seats in the venue that are neither held nor reserved
 *
 * @return the number of tickets available in the venue
 */
 int numSeatsAvailable();
 
 /**
 * Find and hold the best available seats for a customer
 *
 * @param numSeats the number of seats to find and hold
 * @param customerEmail unique identifier for the customer
 * @return a SeatHold object identifying the specific seats and related information
 */
 SeatHold findAndHoldSeats(int numSeats, String customerEmail);
 
 /**
 
 * Commit seats held for a specific customer
 *
 * @param seatHoldId the seat hold identifier
 * @param customerEmail the email address of the customer to which the seat hold is assigned
 * @return a reservation confirmation code
 */
 String reserveSeats(int seatHoldId, String customerEmail);
 
 }
 
 */


//* The number of seats in the venue that are neither held nor reserved

// create the array of seats

// Bidimentional array

// a : available
// h : hold
// r : held reserved

var theaterSeats = [["a", "a", "a", "a", "a"], ["a", "a", "a", "a", "a"], ["a", "a", "a", "a", "a"], ["a", "a", "a", "a", "a"]]

theaterSeats[1][2]
print("---------WELCOME----------")
print("a: Available")
print("h: hold")
print("r: reserverd")
print("----------STAGE-----------")
print("--------------------------")

for i in theaterSeats {
    print(i)
}
//--------------------------


class ManagerTickets {

    var row: Int
    var column: Int
    
    init(row:Int, column:Int) {
        self.row = row
        self.column = column
    }
}



// We check the best seats if they are not confirmed in 5 seconds. they will be unselected.
class Theater: NSObject{
    
    private let arrSaved = theaterSeats
    var timerTest : Timer?
    var count = 5

    
    // The number of seats in the venue that are available neither held nor reserved
    func getAvailableSeats(theaterSeats: [[String]] ) -> Int {
        // Count every a : seat available in the array.
        let seatsA = theaterSeats.map{ $0.filter{$0 == "a"}}.flatMap{$0}
        print("--------------------------")
        //    print("The number of available seats is \(seatsA.count).")
        return seatsA.count
        
    }
    
    func timerHoldSeats(numSeats: Int, clientEmail: String) -> [ManagerTickets]  {
    
    // If dont confirm they go back to available seats
        var arrayObject : [ManagerTickets] = []

        arrayObject = holdSeats(numSeats: numSeats, clientEmail: clientEmail)
    // If not confirmation in 5 seconds, como back to the original array.
        
        guard timerTest == nil else { return arrayObject }

      
        timerTest = Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(self.updateData),
                             userInfo: nil,
                             repeats: true)

        return arrayObject
        }
    
    
    func updateData() {

        if(count > 0) {
            count -= 1
            print(count)
        }
        if count == 0{
            print("Unselected seats")
            timerTest?.invalidate()
            timerTest = nil
            // Return  to "a", the  hold "h" seats in the last state.
            theaterSeats = arrSaved
            for i in theaterSeats {
                print(i)
            }
        }
        
    }
    
    
    //Find and hold the best available seats for a customer
    
    func holdSeats(numSeats: Int, clientEmail: String )-> [ManagerTickets] {
        
        var arrTickets = [ManagerTickets]()
        
        let seatsA = getAvailableSeats(theaterSeats: theaterSeats)
        // Check the array of seats, and select the best seats for a customer
        // if the number of seats required is > than the number of seats available send an alert , "Only numero of seats remaining"
        if seatsA >= numSeats {
            // Search in the first row ,  they have to be together if not continue
            // if no row has all seats togheter divide them in to the front to the back
            // Create an array of the seats Available for row
            let seatsAforRow = theaterSeats.map{ $0.filter{$0 == "a"}}.map{$0.count}
            
            // Check the array to know which row have the number available (Together)
            var row = 0 // to know which is the row with all the seats required.
            //var flag = false // Flag to know if one of the rows has all the seats available.
            var numSeatsRemain = 0 // To know if you reach to the number of seats required
            //[5,5,5,5]
            for _ in seatsAforRow {
                // If the number of seats in the row are >= than the number of seats required
                // Set the seats in h for the row
                //Iterate the row
                for numSeat in 0..<theaterSeats[row].count {
                    // If the seat in that row is "a" change it to "h", only the number of seats that are required, after reach the number break
                    if numSeatsRemain < numSeats {
                        if theaterSeats[row][numSeat] == "a"  {
                            theaterSeats[row][numSeat] = "h"
                            arrTickets.append(ManagerTickets(row: row, column: numSeat))
                            numSeatsRemain += 1
                        } else {
                            // Breack the for loop because it reach the number of seats needed.
                            // break
                        }// end if theaterSeats[row][numSeat] == "a"
                    } else {break}//end if numSeatsRemain < numSeats
                }
                row += 1
            }
            print(seatsAforRow)
        } else {
            print("--------------------------")
            print("We have only \(seatsA) disponible at this moment. Seats Required: \(numSeats) ")
        }
        
        for i in theaterSeats {
            print(i)
        }
        
        // Return reservation code
        print("The number of available seats is \(getAvailableSeats(theaterSeats: theaterSeats)).")
    
        return arrTickets
    }

    func reserveSeat(seatR: Int, seatC:Int, clientEmail: String )-> String {
    
        theaterSeats[seatR][seatC] = "r"
        print("The number of available seats is \(getAvailableSeats(theaterSeats: theaterSeats))).")
        
    return "Ticket. User: \(clientEmail) Your seat reserved is: Row \(seatR), Column: \(seatC). Have a great day! "
    
    }
   
}

// Create a new theater
let theater = Theater()

//Find the number of seats available within the theater
print("The number of available seats is \(theater.getAvailableSeats(theaterSeats: theaterSeats))).")

// Here is te object with returning from the funcion with the seats in hold
var arrayObject : [ManagerTickets] = []

//First test, Uncomment
////Find and hold the best available seats on behalf of a customer
//arrayObject = theater.timerHoldSeats(numSeats: 2, clientEmail: "rob@gmail.com")
//
//for seat in 0..<arrayObject.count {
//
//    let seatInfo = arrayObject[seat]
//    
//    print("Seat Hold, column:\(seatInfo.column), row: \(seatInfo.row)")
//    
//}

// Reserve a seat , generate ticket


//Another test, Uncomment
//print(theater.reserveSeat(seatR: 2, seatC: 2, clientEmail: "Roberto@gmail.com"))
//
//theater.timerHoldSeats(numSeats: 2, clientEmail: "Robert")






















