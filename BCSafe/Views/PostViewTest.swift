//
//  PostViewTest.swift
//  BCSafe
//
//  Created by mike on 4/24/23.
//

import SwiftUI

struct PostViewTest: View {
    var body: some View {
        let postsTest = [Post(id: UUID().uuidString, title: "Test", message: "This is a test", eventLocation: "Test", postedOn: Date.now)]
        
        NavigationStack {
            VStack {
                if postsTest.isEmpty {
                    Text("Nothing To Show")
                        .padding(.top, 300)
                }
                
                List {
                    ForEach(postsTest) { post in
                        NavigationLink {
                            PostView(post: post)
                        } label: {
                            ZStack {
                                Rectangle()
                                    .frame(height: 100)
                                    .foregroundColor(Color("BCGold"))
                                    .cornerRadius(9)
                                
                                VStack {
                                    Text(post.title)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.7)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.system(size: 40))
                                        .bold()
                                    
                                    HStack {
                                        Text(post.message)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .lineLimit(1)
                                        
                                        Text(postAge(date: postsTest[0].postedOn))
                                            .padding(.trailing)
                                    }
                                }
                                .foregroundColor(.black.opacity(0.7))
                                .padding(.leading)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Alerts")
            .listStyle(.plain)
        }
    }
    
    func postAge(date: Date) -> String {
//        var dateHours = date.formatted(.dateTime.hour(.defaultDigits(amPM: .narrow)))
//        if dateHours.contains("p") {
//            dateHours = String(12 + Int(dateHours.replacingOccurrences(of: " p", with: ""))!)
//        } else {
//            dateHours.replacingOccurrences(of: " a", with: "")
//        }
//        var dateMinutes = date.formatted(.dateTime.minute(.twoDigits))
//        var dateDay = date.formatted(.dateTime.day())
        var dateSince = date.timeIntervalSince(Date.now)
        return String(dateSince)
    }
}

struct PostViewTest_Previews: PreviewProvider {
    static var previews: some View {
        PostViewTest()
    }
}
