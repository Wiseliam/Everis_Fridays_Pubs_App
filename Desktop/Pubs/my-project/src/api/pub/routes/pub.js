const { createCoreRouter } = require('@strapi/strapi').factories;

module.exports = createCoreRouter('api::pub.pub', {
    prefix: '',
    config: {
        find: {
            auth: false,
        },
    },
});
