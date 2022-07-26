#!/usr/bin/env node

export async function safe(fun = () => {}) {
    try {
        await fun();
    }
    catch (error) {
        //ignore
    }
};