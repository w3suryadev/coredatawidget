//
//  WidgetKitDemo.swift
//  WidgetKitDemo
//
//  Created by Suryadev Singh on 06/09/23.
//

import WidgetKit
import SwiftUI
import Intents

//import CoreData

struct Provider: IntentTimelineProvider {
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        
        let itemCount = (try? getData().count) ?? 0
        //        let name = (try? getData())
        
        return  SimpleEntry(date: Date(), itemCount: itemCount )
    }
    
    
    func getData() throws -> [FruitEntity] {
        let context = PersistenceController.shared.container.viewContext
        let request = FruitEntity.fetchRequest()
        let result = try context.fetch(request)
        return result
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        do {
            let items = try getData()
            let entry = SimpleEntry(date: Date(), itemCount: items.count)
            completion(entry)
        } catch {
            print(error)
        }
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        
        do {
            let items = try getData()
            let entry = SimpleEntry(date: Date(),itemCount: items.count)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        } catch {
            print(error)
        }
        //        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        //        let currentDate = Date()
        //        for hourOffset in 0 ..< 2 {
        //            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
        //            let entry = SimpleEntry(date: entryDate, configuration: configuration)
        //
        //            let refreshDate = Calendar.current.date(byAdding: .minute, value: 60, to: entryDate)!
        //            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        //            entries.append(entry)
        //        }
        //
        //        let timeline = Timeline(entries: entries, policy: .atEnd)
        //        completion(timeline)
    }
}



// This is the view
// Here we code how it will be visable on screen
struct widgetKitDemoEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    //
    @Environment(\.managedObjectContext) private var viewContext
    //
    //    @FetchRequest(entity: FruitEntity.entity(),
    //                  sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)])
    //
    //    var fruits:FetchedResults<FruitEntity>
    
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<FruitEntity>
    
    let fixed: [GridItem] = [.init(.fixed(155)),.init(.fixed(155))]
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            ZStack {
                Color(UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1))
                VStack(alignment: .leading, spacing: 0) {
                    Text("Task's").foregroundColor(.white).fontWeight(.semibold).padding(.bottom,10)
                    VStack(alignment: .leading, spacing: 6,content: {
                        
                        if items.isEmpty {
                            Text("No Task's Found").font(.caption).foregroundColor(.white).frame(maxWidth: .infinity,maxHeight: .infinity)
                        } else {
        
                            ForEach(items.prefix(3)) { item in
                                HStack(spacing: 6){
                                    Image(systemName: "circle").foregroundColor(.white).frame(width: 12, height: 12)
                                    VStack(alignment: .leading,spacing: 4, content: {
                                        Text(item.name!).foregroundColor(.white).lineLimit(1).font(.custom("Satoshi-Regular", size: 12))
                                    })
                                }
                                .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                                .frame(width: 120, height: 28,alignment: .leading)
                                .background(Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.05).cgColor))
                                .cornerRadius(15)
                                Divider()


                            }
                            
                        }
                        
                    })
                }.padding()
            }
            
            
        case .systemMedium:
            
            ZStack {
                Color(UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1))
                VStack(alignment: .leading, spacing: 0) {
//                    Text("Task's").foregroundColor(.white).fontWeight(.semibold).padding(.bottom,10)
                    VStack(alignment: .leading, spacing: 6,content: {
                        
                        if items.isEmpty {
                            Text("No Task's Found").font(.caption).foregroundColor(.white).frame(maxWidth: .infinity,maxHeight: .infinity)
                        } else {
                            
                            LazyVGrid(columns: fixed, spacing: 5,pinnedViews: [.sectionHeaders]) {
                                    Section(header: Text("Task's").foregroundColor(.white).fontWeight(.semibold).padding(10)){
                                            ForEach(items.prefix(6)){ item in
                                            HStack(spacing: 6){
                                                Image(systemName: "circle").foregroundColor(.white).frame(width: 12, height: 12)
                                                VStack(alignment: .leading,spacing: 4, content: {
                                                    Text(item.name!).foregroundColor(.white).lineLimit(1).font(.custom("Satoshi-Regular", size: 12))
                                                })
                                            }
                                            .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                                            .frame(width: 156, height: 28,alignment: .leading)
                                            .background(Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.05).cgColor))
                                            .cornerRadius(15)
                                            
//                                        }
//                                    }
//                                        ForEach(items) { item in
//                                            HStack(spacing: 6){
//                                                Image(systemName: "circle").foregroundColor(.white).frame(width: 12, height: 12)
//                                                VStack(alignment: .leading,spacing: 4, content: {
//                                                    Text(item.name!).foregroundColor(.white).lineLimit(1).font(.custom("Satoshi-Regular", size: 12))
//                                                })
//                                            }
//                                            .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
//                                            .frame(width: 126, height: 28,alignment: .leading)
//                                            .background(Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.05).cgColor))
//                                            .cornerRadius(15)
//                                            Divider()


                                        }
                                    }
                                }
//                            Grid {
//                                GridRow {
//                                    ForEach(items) { item in
//                                        HStack(spacing: 6){
//                                            Image(systemName: "circle").foregroundColor(.white).frame(width: 12, height: 12)
//                                            VStack(alignment: .leading,spacing: 4, content: {
//                                                Text(item.name!).foregroundColor(.white).lineLimit(1).font(.custom("Satoshi-Regular", size: 12))
//                                            })
//                                        }
//                                        .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
//                                        .frame(width: 126, height: 28,alignment: .leading)
//                                        .background(Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.05).cgColor))
//                                        .cornerRadius(15)
//                                        Divider()
//
//
//                                    }
//                                }
//                                //                                GridRow {
//                                //                                    Image(systemName: "hand.wave")
//                                //                                    Text("World")
//                                //                                }
//                            }
                            //                            .frame(width:200,height: 60).background(Color.yellow)
                            
                            
                        }
                        
                    })
                }.padding()
            }
            
            
            
        case .systemLarge:
            ZStack {
                Color.green
                
                VStack {
                    Text("Large widget")
                    ForEach(items) { item in
                        Text(item.name!)
                    }
                    Text(entry.itemCount,format: .number )
                    Text(entry.date,style: .time)
                }
            }
        case .systemExtraLarge:
            ZStack {
                Color.blue
                
                VStack {
                    Text("Extra Large widget")
                    ForEach(items) { item in
                        Text(item.name!)
                    }
                    Text(entry.itemCount,format: .number )
                    Text(entry.date,style: .time)
                }
            }
            
        default:
            fatalError()
            
        }
    }
}

struct widgetKitDemo: Widget {
    let persistenceController = PersistenceController.shared
    
    let kind: String = "WidgetKitDemo"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetKitDemoEntryView(entry: entry)
                .environment(\.managedObjectContext,
                              persistenceController.container.viewContext)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct widgetKitDemo_Previews: PreviewProvider {
    static var previews: some View {
        widgetKitDemoEntryView(entry: SimpleEntry(date: Date(), itemCount: 0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
