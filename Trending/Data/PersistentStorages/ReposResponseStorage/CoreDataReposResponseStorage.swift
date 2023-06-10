//
//  CoreDataReposResponseStorage.swift
//  Trending
//
//  Created by Amr Saied on 01/03/2023.
//



import Foundation
import CoreData

final class CoreDataReposResponseStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private

    private func fetchRequest(for requestDto: ReposRequestDTO) -> NSFetchRequest<ReposRequestEntity> {
        let request: NSFetchRequest = ReposRequestEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@ AND %K = %d AND %K = %@",
                                        #keyPath(ReposRequestEntity.q), requestDto.q,
                                        #keyPath(ReposRequestEntity.page), requestDto.page,
                                        #keyPath(ReposRequestEntity.sort), requestDto.sort
        
        )
        return request
    }

    private func deleteResponse(for requestDto: ReposRequestDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest(for: requestDto)

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
}

extension CoreDataReposResponseStorage: ReposResponseStorage {

    func getResponse(for requestDto: ReposRequestDTO, completion: @escaping (Result<ReposResponseDTO?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: requestDto)
                let requestEntity = try context.fetch(fetchRequest).first

                 completion(.success(requestEntity?.response?.toDTO()))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    func save(response responseDto: ReposResponseDTO, for requestDto: ReposRequestDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: requestDto, in: context)

                let requestEntity = requestDto.toEntity(in: context)
                requestEntity.response = responseDto.toEntity(in: context)

                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataReposResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
