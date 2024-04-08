// AddCustomerForm.jsx
import React, { useState } from 'react';
import { createCustomer } from '../services/CustomerService';

function AddCustomerForm() {
    const [customer, setCustomer] = useState({ name: '', email: '', phone: '' });

    const handleChange = (e) => {
        const { name, value } = e.target;
        setCustomer({...customer, [name]: value });
    }

    const handleSubmit = (e) => {
        e.preventDefault();
        createCustomer(customer).then(() => {
            // Post-submit logic here (e.g., redirect, clear form, show message)
        });
    }

    return (
        <form onSubmit={handleSubmit}>
            <label>Name: <input type="text" name="name" value={customer.name} onChange={handleChange} /></label>
            <label>Email: <input type="email" name="email" value={customer.email} onChange={handleChange} /></label>
            <label>Phone: <input type="text" name="phone" value={customer.phone} onChange={handleChange} /></label>
            <button type="submit">Add Customer</button>
        </form>
    );
}

export default AddCustomerForm;
