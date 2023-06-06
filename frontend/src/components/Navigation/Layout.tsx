import React from 'react'
import { LayoutProps } from '../@types/layout'
import Navbar from './Navbar'
const Layout = ({ children }: LayoutProps) => {
    return (
        <div>
            <Navbar />
            <div>{children}</div>
        </div>
    )
}

export default Layout