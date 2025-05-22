import SwiftUI
import Resolver

struct NotesListView: View {
    @StateObject var viewModel: NotesViewModel = Resolver.resolve()
    @State private var selectedDate: Date = Date()
    @State private var showDatePicker: Bool = false
    @State private var tagSearchText: String = ""
    @State private var showingCreateNote = false
    @State private var showingEditNote = false
    @State private var noteToEdit: Note? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            // Create Note Button
            Button(action: {
                showingCreateNote.toggle()
            }) {
                Label("Create Note", systemImage: "plus")
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(20)
            
            // Filter Controls
            filterControls
            
            // Notes List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredNotes, id: \.id) { note in
                        NoteItemView(
                            title: note.title,
                            date: note.date,
                            bodyText: note.bodyText,
                            tags: note.tags,
                            onEdit: {
                                noteToEdit = note
                                showingEditNote = true
                            },
                            onDelete: {
                                viewModel.deleteNote(note)
                            }
                        )
                    }
                }
            }
        }
        .padding()
        .navigationTitle("My Notes")
        .sheet(isPresented: $showDatePicker) {
            datePickerSheet
        }
        .sheet(isPresented: $showingCreateNote) {
            AddNoteView { newNote in
                viewModel.addNote(newNote)
                showingCreateNote = false
            }
        }
        .sheet(item: $noteToEdit) { note in
            EditNoteView(
                isPresented: Binding(
                    get: { noteToEdit != nil },
                    set: { newValue in
                        if !newValue { noteToEdit = nil }
                    }
                ),
                title: note.title,
                noteBody: note.bodyText,
                tags: note.tags.joined(separator: ", ")
            ) { updatedTitle, updatedBody, updatedTags in
                viewModel.updateNote(
                    note: note,
                    title: updatedTitle,
                    body: updatedBody,
                    tags: updatedTags
                )
            }
        }
        .onAppear {
            Task {
                await viewModel.loadNotes()
            }
        }
    }
    
    // MARK: - Filtered Notes (Date + Reversed)
    var filteredNotes: [Note] {
        viewModel.notes
            .filter { note in
                // Match date
                let sameDay = Calendar.current.isDate(note.date, inSameDayAs: selectedDate)
                
                // Match tag search if text is entered
                let matchesTag: Bool = tagSearchText.isEmpty ||
                    note.tags.contains { tag in
                        tag.localizedCaseInsensitiveContains(tagSearchText)
                    }
                
                return sameDay && matchesTag
            }
            .sorted(by: { $0.date > $1.date }) // Latest notes first
    }
    
    // MARK: - Filter Controls
    private var filterControls: some View {
        HStack(spacing: 12) {
            Text("Filter by:")
            
            Button(action: {
                showDatePicker.toggle()
            }) {
                HStack {
                    Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                    Image(systemName: "calendar")
                }
                .padding(8)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
            }
            
            Text("Tags:")
            
            TextField("Search tags", text: $tagSearchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 120)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Date Picker Sheet
    private var datePickerSheet: some View {
        VStack {
            DatePicker(
                "Select a date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .padding()
            
            Button("Done") {
                showDatePicker = false
            }
            .padding()
        }
    }
}
