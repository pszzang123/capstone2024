package com.example.demo.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.CustomerDto;
import com.example.demo.service.CustomerService;

import lombok.AllArgsConstructor;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/api/customers")
public class CustomerController {
    private CustomerService customerService;

    @PostMapping
    public ResponseEntity<CustomerDto> createCustomer(@RequestBody CustomerDto customerDto) {
        CustomerDto savedCustomer = customerService.createCustomer(customerDto);
        return new ResponseEntity<>(savedCustomer, HttpStatus.CREATED);
    }

    @GetMapping("{id}")
    public ResponseEntity<CustomerDto> getCustomerByEmail(@PathVariable("id") String customerEmail) {
        CustomerDto customerDto = customerService.getCustomerByEmail(customerEmail);
        return ResponseEntity.ok(customerDto);
    }

    @GetMapping("{id}/{password}")
    public ResponseEntity<Boolean> checkCustomerByLoginInfo(@PathVariable("id") String customerEmail, @PathVariable("password") String customerPassword) {
        CustomerDto customerDto = customerService.getCustomerByEmail(customerEmail);
        Boolean isTrue = (customerDto.getPassword().equals(customerPassword));
        return ResponseEntity.ok(isTrue);
    }

    @GetMapping("email/{id}")
    public ResponseEntity<Boolean> checkCustomerByEmail(@PathVariable("id") String customerEmail) {
        Boolean isPresent = customerService.checkCustomerByEmail(customerEmail);
        return ResponseEntity.ok(isPresent);
    }

    @GetMapping
    public ResponseEntity<List<CustomerDto>> getAllCustomers() {
        List<CustomerDto> customers = customerService.getAllCustomers();
        return ResponseEntity.ok(customers);
    }

    @PutMapping("{id}")
    public ResponseEntity<CustomerDto> updateCustomer(@PathVariable("id") String customerEmail, @RequestBody CustomerDto updatedCustomer) {
        CustomerDto customerDto = customerService.updateCustomer(customerEmail, updatedCustomer);
        return ResponseEntity.ok(customerDto);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<String> deleteCustomer(@PathVariable("id") String customerEmail) {
        customerService.deleteCustomer(customerEmail);
        return ResponseEntity.ok("Customer deleted successfully.");
    }
}
