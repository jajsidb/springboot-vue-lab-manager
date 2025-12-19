package com.example.labequipment.service;

import com.example.labequipment.entity.BorrowRecord;
import com.example.labequipment.repository.BorrowRecordRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class BorrowService {
    @Autowired
    private BorrowRecordRepository borrowRecordRepository;

    public List<BorrowRecord> getAllRecords() {
        return borrowRecordRepository.findAll();
    }

    public List<BorrowRecord> getUserRecords(String userName) {
        return borrowRecordRepository.findByUserName(userName);
    }

    public BorrowRecord saveRecord(BorrowRecord record) {
        return borrowRecordRepository.save(record);
    }
    
    public boolean checkConflict(Long deviceId, LocalDateTime startTime, LocalDateTime endTime) {
        List<BorrowRecord> records = borrowRecordRepository.findByDeviceId(deviceId);
        for (BorrowRecord record : records) {
            if ("rejected".equals(record.getStatus()) || "returned".equals(record.getStatus())) {
                continue;
            }
            if (startTime.isBefore(record.getEndTime()) && endTime.isAfter(record.getStartTime())) {
                return true;
            }
        }
        return false;
    }
    
    public BorrowRecord getRecordById(Long id) {
        return borrowRecordRepository.findById(id).orElse(null);
    }
}
