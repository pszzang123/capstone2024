package com.example.demo.service.impl;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.CustomerDto;
import com.example.demo.entity.Cart;
import com.example.demo.entity.Customer;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.CartRepository;
import com.example.demo.repository.CustomerRepository;
import com.example.demo.service.CustomerService;
import com.example.mapper.CustomerMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class CustomerServiceImpl implements CustomerService {
    private CustomerRepository customerRepository;
    private CartRepository cartRepository;

    @Override
    public CustomerDto createCustomer(CustomerDto customerDto) {
        Optional<Customer> customer_check = customerRepository.findById(customerDto.getEmail());
        if (!customer_check.isPresent()) {
            Customer customer = CustomerMapper.mapToCustomer(customerDto);
            Customer savedCustomer = customerRepository.save(customer);
            return CustomerMapper.mapToCustomerDto(savedCustomer);
        }
        else {
            return null;
        }
    }

    @Override
    public Boolean checkCustomerByEmail(String customerEmail) {
        Optional<Customer> checkCustomer = customerRepository.findById(customerEmail);
        Boolean isPresent = checkCustomer.isPresent();
        return isPresent;
    }

    @Override
    public CustomerDto getCustomerByEmail(String customerEmail) {
        Customer customer = customerRepository.findById(customerEmail).orElseThrow(() -> 
            new ResourceNotFoundException("Customer is not exists with given id : " + customerEmail)
        );
        
        return CustomerMapper.mapToCustomerDto(customer);
    }

    @Override
    public List<CustomerDto> getAllCustomers() {
        List<Customer> customers = customerRepository.findAll();
        return customers.stream().map((customer) -> CustomerMapper.mapToCustomerDto(customer)).collect(Collectors.toList());
    }

    @Override
    public CustomerDto updateCustomer(String customerEmail, CustomerDto updatedCustomer) {
        Customer customer = customerRepository.findById(customerEmail).orElseThrow(
            () -> new ResourceNotFoundException("Customer is not exists with given id : " + customerEmail)
        );

        customer.setPassword(updatedCustomer.getPassword());
        customer.setName(updatedCustomer.getName());
        customer.setAddress(updatedCustomer.getAddress());
        customer.setPhone(updatedCustomer.getPhone());

        Customer updatedCustomerObj = customerRepository.save(customer);

        return CustomerMapper.mapToCustomerDto(updatedCustomerObj);
    }

    @Override
    public void deleteCustomer(String customerEmail) {
        List<Cart> carts = null;
        Customer customer = customerRepository.findById(customerEmail).orElseThrow(() -> 
            new ResourceNotFoundException("Clothes are not exist with given id : " + customerEmail)
        );
        carts = cartRepository.findAllByCustomer(customer);
        if (carts != null) {
            carts.forEach((cart) -> {
                cartRepository.delete(cart);
            });
        }

        customerRepository.deleteById(customerEmail);
    }
}
