package com.example.demo.service.impl;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.CustomerDto;
import com.example.demo.entity.Cart;
import com.example.demo.entity.CartId;
import com.example.demo.entity.Customer;
import com.example.demo.entity.Seller;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.CartRepository;
import com.example.demo.repository.CustomerRepository;
import com.example.demo.repository.SellerRepository;
import com.example.demo.service.CustomerService;
import com.example.demo.service.SellerService;
import com.example.mapper.CustomerMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class CustomerServiceImpl implements CustomerService {
    private CustomerRepository customerRepository;
    private SellerRepository sellerRepository;
    private CartRepository cartRepository;
    private SellerService sellerService;

    @Override
    public CustomerDto createCustomer(CustomerDto customerDto) {
        Customer customer = CustomerMapper.mapToCustomer(customerDto);
        Customer savedCustomer = customerRepository.save(customer);
        return CustomerMapper.mapToCustomerDto(savedCustomer);
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
                CartId cartId = new CartId(cart.getCustomer(), cart.getClothes());
                cartRepository.deleteById(cartId);
            });
        }
        
        Optional<Seller> sellerEntity = sellerRepository.findById(customerEmail);
        if (sellerEntity.isPresent()) {
            sellerService.deleteSeller(customerEmail);
        }
        customerRepository.deleteById(customerEmail);
    }
}
