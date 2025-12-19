package com.example.labequipment.controller;

import com.example.labequipment.entity.BorrowRecord;
import com.example.labequipment.service.BorrowService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/borrow")
public class BorrowController {
    @Autowired
    private BorrowService borrowService;

    @GetMapping
    public List<BorrowRecord> getAllRecords() {
        return borrowService.getAllRecords();
    }
    
    @GetMapping("/user/{userName}")
    public List<BorrowRecord> getUserRecords(@PathVariable String userName) {
        return borrowService.getUserRecords(userName);
    }

    @PostMapping("/apply")
    public ResponseEntity<?> applyBorrow(@RequestBody BorrowRecord record) {
        if (borrowService.checkConflict(record.getDeviceId(), record.getStartTime(), record.getEndTime())) {
            return ResponseEntity.badRequest().body("Device is already booked for this time period.");
        }
        record.setStatus("pending");
        return ResponseEntity.ok(borrowService.saveRecord(record));
    }
    
    @PostMapping("/status/{id}")
    public BorrowRecord updateStatus(@PathVariable Long id, @RequestBody String status) {
        BorrowRecord record = borrowService.getRecordById(id);
        if (record != null) {
            // Remove quotes if present
            status = status.replace("\"", "");
            record.setStatus(status);
            return borrowService.saveRecord(record);
        }
        return null;
    }
}
