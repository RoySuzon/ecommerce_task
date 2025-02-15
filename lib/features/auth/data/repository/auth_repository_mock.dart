import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/services/secure_storage.dart';
import 'package:ecommerce/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryMock implements AuthRepository {
  final secureStorageService = SecureStorageService();
  @override
  Future<bool> logout() async {
    return true;
  }

  @override
  Future<Either<Failure, dynamic>> login(String email, String passaword) async {
    return Right({
      "status": true,
      "message": "Login Successful.",
      "token": "1620|ylkQLOAoXqLV1EP9uktwebm5UcsWtc8dVW14wqRE",
      "id": 480,
      "data": {
        "id": 480,
        "name": "Super Admin",
        "roaster_group_id": null,
        "user_type": "admin",
        "depot_id": null,
        "card_no": "SA000001",
        "email": "admin@gmail.com",
        "password":
            r"$2y$10$JwtMdS5xH.XTBVg0pUsiWOjBVnzCb3.5dWDLJVblKNrnzX13gXW.y",
        "mobile": "1958577523",
        "type": "permanent",
        "joining_date": "2021-12-18",
        "inactive_date": "2022-12-11",
        "bank_account": "1212121212",
        "blood_group": "O+",
        "date_of_birth": "1996-12-21",
        "present_address": "Super Admin",
        "permanent_address": null,
        "emergency_contact": "01722222222",
        "reference": null,
        "grade_id": 10,
        "designation_id": 5,
        "department_id": 23,
        "requisition_id": null,
        "candidate_id": null,
        "company_location_id": 1,
        "workplace_id": null,
        "workplace_type": null,
        "notes": null,
        "department_head": 0,
        "approved_by": 0,
        "status": "active",
        "created_at": null,
        "updated_at": "2023-10-07T12:26:12.000000Z",
        "deleted_at": null,
      },
    });
  }
}
