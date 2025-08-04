'use strict';

const { filter } = require('../../../../config/middlewares');

/**
 * pub controller
 */

// @ts-ignore
const { createCoreController } = require('@strapi/strapi').factories;

module.exports = createCoreController('api::pub.pub', ({ strapi }) => ({

    async find(ctx) {
        let result  = await strapi.entityService.findMany('api::pub.pub', {populate: '*'});
        return result
    },

    async getAffordablePubs(ctx) {
        const maxPrice = ctx.query.maxPrice ? Number(ctx.query.maxPrice) : 15;
        const sortOrder = ctx.query.sort;
        const pubs = await strapi.service('api::pub.pub').getAffordablePubs(maxPrice, sortOrder);
        return pubs;
    }
        
}));