package com.example.mapper;

import com.example.demo.dto.CustomerDto;
import com.example.demo.entity.Customer;

public class CustomerMapper {
    public static CustomerDto mapToCustomerDto(Customer customer) {
        return new CustomerDto(
            customer.getEmail(),
            customer.getPassword(),
            customer.getName(),
            customer.getStreetAddress(),
            customer.getDetailAddress(),
            customer.getZipCode(),
            customer.getPhone()
        );
    }

    public static Customer mapToCustomer(CustomerDto customerDto) {
        return new Customer(
            customerDto.getEmail(),
            customerDto.getPassword(),
            customerDto.getName(),
            customerDto.getStreetAddress(),
            customerDto.getDetailAddress(),
            customerDto.getZipCode(),
            customerDto.getPhone()
        );
    }
}
