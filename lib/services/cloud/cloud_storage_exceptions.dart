class CloudStorageException implements Exception {
  const CloudStorageException();
}

//C in crud
class CouldNotCreateNoteException extends CloudStorageException {}

//R in crud
class CouldNoteGetAllNotesException extends CloudStorageException {}

//U in crud
class CouldNotUpdateNoteException extends CloudStorageException {}

//D in crud
class CouldNotDeleteNoteException extends CloudStorageException {}
