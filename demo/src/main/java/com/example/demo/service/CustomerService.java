package com.example.demo.service;

import java.util.List;

import com.example.demo.dto.CustomerDto;

public interface CustomerService {
    CustomerDto createCustomer(CustomerDto customerDto);

    CustomerDto getCustomerByEmail(String customerEmail);

    List<CustomerDto> getAllCustomers();

    CustomerDto updateCustomer(String customerEmail, CustomerDto updatedCustomer);

    void deleteCustomer(String customerEmail);
}
