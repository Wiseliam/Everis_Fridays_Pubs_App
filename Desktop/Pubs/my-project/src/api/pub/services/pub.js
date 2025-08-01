'use strict';

/**
 * pub service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::pub.pub', ({ strapi }) => ({

async getAffordablePubs(maxPrice = 15, sortOrder) {

    console.log('chiamata a /api/services ricevuta');

    const pubs = await strapi.entityService.findMany('api::pub.pub', {
    filters: {
    avgPrice: {
    $lte: maxPrice
    }
    },
    populate: '*',
    sort: { avgPrice: sortOrder === 'asc' ? 'asc' : 'desc' }
    });
    return pubs;
}
        
}));