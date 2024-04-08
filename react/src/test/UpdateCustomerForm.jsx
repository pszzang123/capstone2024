// UpdateCustomerForm.jsx
import React, { useState, useEffect } from 'react';
import { getCustomer, updateCustomer } from '../services/CustomerService';

function UpdateCustomerForm({ customerEmail }) {
    const [customer, setCustomer] = useState({ name: '', email: '', phone: '' });

    useEffect(() => {
        getCustomer(customerEmail).then(response => {
            setCustomer(response.data);
        });
    }, [customerEmail]);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setCustomer({...customer, [name]: value });
    }

    const handleSubmit = (e) => {
        e.preventDefault();
        updateCustomer(customerEmail, customer).then(() => {
            // Post-submit logic here
        });
    }

    return (
        <form onSubmit={handleSubmit}>
            <label>Name: <input type="text" name="name" value={customer.name} onChange={handleChange} /></label>
            <label>Email: <input type="email" name="email" value={customer.email} onChange={handleChange} disabled /></label>
            <label>Phone: <input type="text" name="phone" value={customer.phone} onChange={handleChange} /></label>
            <button type="submit">Update Customer</button>
        </form>
    );
}

export default UpdateCustomerForm;
