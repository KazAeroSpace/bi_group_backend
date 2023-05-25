/**
 * arcgis controller
 */

import {factories} from '@strapi/strapi'
import {validateGetTokenBody} from './validation'

export default factories.createCoreController('api::arcgis.arcgis', ({ strapi }) => ({
  auth: async (ctx) => {
    await validateGetTokenBody(ctx.request.body)
    ctx.body = await strapi.service('api::arcgis.arcgis').auth(ctx.request.body)
  }
}));
