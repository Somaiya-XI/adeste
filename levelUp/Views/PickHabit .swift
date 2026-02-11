//


import SwiftUI

struct HabitPickerView: View {
    @State private var selectedHabits: Set<String> = []
    @Environment(\.dismiss) var dismiss
    let habitLimit: Int
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
           
            HStack(spacing: 12) {
                
                
                Button(action: {
                    dismiss()
                }) {
                    Image("ic_back")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .frame(width: 50, height: 50)
                        .background(Color(red: 0.85, green: 0.78, blue: 0.68))
                        .clipShape(Circle())
                }
                
                Text("Pick habits")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color("brand-color"))
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            
            // Content Card
            VStack(spacing: 0) {
                Text("Pick two habits to start the cycle")
                    .font(.system(size: 17))
                    .foregroundColor(Color("brand-color"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 24)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                
                // Habits
                HStack(alignment: .top, spacing: 16) {
               
                    
                    VStack(spacing: 16) { // prayyyyyyy iocn
                        HabitCard(
                            title: "Pray",
                            icon: .custom("Mosque"),
                                isSelected: selectedHabits.contains("Pray")
                        ) {
                            toggleHabit("Pray")
                        }
                        
                        HabitCard(
                            title: "Drink water",
        
                            icon: .doubleBottle,
                            isSelected:
                                selectedHabits.contains("Drink water")
                        ) {
                            toggleHabit("Drink water")
                        }
                    }
                    
                    VStack(spacing: 16) {
                        HabitCard(
                            title: "Walk",
                            icon: .system("figure.walk.motion"),
                            
                            isSelected: selectedHabits.contains("Walk")
                        ) {
                            toggleHabit("Walk")
                        }
                        
                        HabitCard(
                            title: "Athkar",
                            icon: .system("book.fill"),
                    
                            isSelected: selectedHabits.contains("Athkar")
                        ) {
                            toggleHabit("Athkar")
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                HabitCard(
                    title: "Wake Up",
                    icon: .system("sun.max.fill"),
        
                    isSelected: selectedHabits.contains("Wake Up"),
                    isWide: true
                ) {
                    toggleHabit("Wake Up")
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
            .background(Color("base-shade-01"))
            .cornerRadius(20)
            .padding(.horizontal, 20)
            .padding(.top, 30)
            
            Spacer()
            
            // Get Started Button
            Button(action: {
            }) {
                Text("Get Started")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(Color("brand-color"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                    .background(Color("base-shade-02"))
                    .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)

    }
    
    private func toggleHabit(_ habit: String) {

        if selectedHabits.contains(habit) {
            selectedHabits.remove(habit)
        } else {
            if selectedHabits.count < habitLimit {
                selectedHabits.insert(habit)
            }
        }
    }
}

struct HabitCard: View {
    let title: String
    let icon: IconType
    let isSelected: Bool
    var isWide: Bool = false
    let action: () -> Void
    
    enum IconType {
        case system(String)
        case custom(String)
        case doubleBottle
    }
    
    var body: some View {
        Button(action: action) {
            if isWide {
             
                HStack(spacing: 20) {
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 70))
                        .foregroundColor(Color("brand-color"))
                    
                    Text(title)
                        .font(.system(size: 29, weight: .regular))
                        .foregroundColor(Color("brand-color"))
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color("brand-color") : Color.clear, lineWidth: 3)
                )
            } else {
                VStack(spacing: 12) {
                    Spacer()
                    
                    // Icon
                    Group {
                        switch icon {
                        case .system(let systemName):
                            Image(systemName: systemName)
                                .font(.system(size: iconSize))
                                .foregroundColor(Color("brand-color"))
                        case .custom(let imageName):
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)
                                .foregroundColor(Color("brand-color"))
                        case .doubleBottle:
                            HStack(spacing: 4) {
                                Image(systemName: "waterbottle.fill")
                                    .font(.system(size: 65))
                                    .foregroundColor(Color("brand-color"))
                                Image(systemName: "waterbottle.fill")
                                    .font(.system(size: 65))
                                    .foregroundColor(Color("brand-color"))
                            }
                        }
                    }
                    
                    // Title
                    Text(title)
                        .font(.system(size: 28, weight: .regular))
                        .foregroundColor(Color("brand-color"))
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: cardHeight)
                .background(Color.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color("brand-color") : Color.clear, lineWidth: 3)
                )
            }
        }
    }
    
    private var iconSize: CGFloat {
        switch title {
        case "Walk":
            return 75
        case "Athkar":
            return 70
        default:
            return 65
        }
    }
    
    private var cardHeight: CGFloat {
        switch title {
        case "Walk", "Drink water":
            return 180
        case "Pray", "Athkar":
            return 150
        default:
            return 160
        }
    }
}

struct HabitPickerView_Previews: PreviewProvider {
    static var previews: some View {
        HabitPickerView(habitLimit: 2)
    }
}
